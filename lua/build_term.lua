-- cmake-tools executor that runs builds in the background inside a dedicated
-- toggleterm terminal named "build", replacing the quickfix window.
--
-- The terminal never opens by itself; progress and result are exposed via
-- M.status() for the statusline (lualine's "Build" component), and the
-- output can be looked at on demand with M.toggle() / :CMakeOpenExecutor.
--
-- The terminal is created with `hidden = true` and a fixed, high id so that
-- toggleterm's own toggling (<c-\>, :ToggleTerm, :ToggleTermToggleAll) never
-- picks it up, and so <c-\> never creates "terminal 1" on top of it.
-- Registered under the executor name "build" in cmake-tools.lua.

local Terminal = require("toggleterm.terminal").Terminal
local utils = require("cmake-tools.utils")
local log = require("cmake-tools.log")

local M = {
  ID = 99,
  term = nil,
  job_running = false,
  cmd = nil,
  -- nil (no build yet) | "running" | "success" | "failed"
  state = nil,
  progress = nil,
  opts = { direction = "horizontal", size = 12 },
}

local function refresh_statusline()
  local ok, lualine = pcall(require, "lualine")
  if ok then
    lualine.refresh({ place = { "statusline" } })
  end
end

local function is_open()
  return M.term ~= nil and M.term:is_open()
end

function M.show(opts)
  if not M.term or is_open() then
    return
  end
  M.term:open(opts.size, opts.direction)
  M.term:scroll_bottom()
end

function M.close(opts)
  if is_open() then
    M.term:close()
  end
end

local function build_cmd(cmd, env_script, env, args, cwd)
  local parts = { "cd", vim.fn.shellescape(cwd), "&&" }
  if env_script and env_script:match("^%s*$") == nil then
    table.insert(parts, (env_script:gsub("%s*$", "")))
    table.insert(parts, "&&")
  end
  if not vim.tbl_isempty(env) then
    table.insert(parts, "env")
    for k, v in pairs(env) do
      table.insert(parts, vim.fn.shellescape(k .. "=" .. v))
    end
  end
  table.insert(parts, utils.shell_quote(cmd))
  for _, arg in ipairs(args) do
    table.insert(parts, utils.shell_quote(arg))
  end
  return table.concat(parts, " ")
end

-- cmake-tools' progress notifications expect single lines, toggleterm hands
-- over raw terminal chunks.
local function last_line(data)
  for i = #data, 1, -1 do
    local line = data[i]:gsub("\r", ""):gsub("\27%[[%d;?]*%a", "")
    if line ~= "" then
      return line
    end
  end
end

-- "[ 42%] ..." (Makefiles) or "[17/40] ..." (Ninja)
local function parse_progress(line)
  local pct = line:match("^%[%s*(%d+)%%%]")
  if pct then
    return pct .. "%%"
  end
  local done, total = line:match("^%[(%d+)/(%d+)%]")
  if done then
    return done .. "/" .. total
  end
end

function M.run(cmd, env_script, env, args, cwd, opts, on_exit, on_output)
  if M.term then
    M.term:shutdown()
  end
  M.cmd = build_cmd(cmd, env_script, env, args, cwd)
  M.opts = opts
  M.job_running = true
  M.state = "running"
  M.progress = nil
  refresh_statusline()

  local function output(data, is_err)
    local line = last_line(data)
    if not line then
      return
    end
    M.progress = parse_progress(line) or M.progress
    if is_err then
      on_output(nil, line)
    else
      on_output(line)
    end
  end

  M.term = Terminal:new({
    id = M.ID,
    display_name = "build",
    hidden = true,
    cmd = M.cmd,
    dir = cwd,
    direction = opts.direction,
    close_on_exit = false,
    auto_scroll = true,
    on_stdout = function(_, _, data)
      output(data, false)
    end,
    on_stderr = function(_, _, data)
      output(data, true)
    end,
    on_exit = function(_, _, code)
      M.job_running = false
      M.cmd = nil
      M.state = code == 0 and "success" or "failed"
      vim.schedule(function()
        refresh_statusline()
        on_exit(code)
      end)
    end,    on_create = function(t)
      local o = { buffer = t.bufnr, silent = true, nowait = true }
      vim.keymap.set("n", "<CR>", M.jump_to_location, o)
      vim.keymap.set("n", "<2-LeftMouse>", M.jump_to_location, o)
      vim.keymap.set("n", "<LeftRelease>", function()
        M.jump_to_location(true)
      end, o)
    end,
    on_open = function()
      -- normal mode, so clicks and <CR> reach the mappings above (any key
      -- in terminal mode would also close the exited terminal)
      vim.schedule(function()
        vim.cmd("stopinsert")
      end)
    end,
  })
  -- start the job without a window
  M.term:spawn()
end

-- "path/file.cpp:12:5: error: ..." (gcc/clang), also "In file included
-- from path/file.h:3," and "path/file.cpp:12: undefined reference ...".
local function parse_location(text)
  local file, lnum, col = text:match("([^%s:,]+%.%w+):(%d+):(%d+)")
  if not file then
    file, lnum = text:match("([^%s:,]+%.%w+):(%d+)")
  end
  if file then
    return file, tonumber(lnum), tonumber(col) or 1
  end
end

local function resolve(file)
  if file:sub(1, 1) == "/" then
    return vim.fn.filereadable(file) == 1 and file or nil
  end
  for _, base in ipairs({ M.term and M.term.dir, vim.fn.getcwd() }) do
    local path = base and vim.fs.normalize(base .. "/" .. file)
    if path and vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

-- Long lines are hard-wrapped in the terminal buffer, so a location can be
-- split across the cursor line and its neighbours.
local function location_at_cursor()
  local row = vim.fn.line(".")
  local get = function(r)
    return vim.fn.getline(r)
  end
  local candidates = {
    get(row),
    get(row) .. get(row + 1),
    get(row - 1) .. get(row),
    get(row - 1) .. get(row) .. get(row + 1),
  }
  for _, text in ipairs(candidates) do
    local file, lnum, col = parse_location(text)
    local path = file and resolve(file)
    if path then
      return path, lnum, col
    end
  end
end

-- Jump to the error/warning under the cursor, like <CR> in the quickfix
-- window. `quiet`: do nothing on lines without a location (plain clicks).
function M.jump_to_location(quiet)
  local path, lnum, col = location_at_cursor()
  if not path then
    if quiet ~= true then
      vim.notify("build: no file location on this line", vim.log.levels.INFO)
    end
    return
  end
  local build_win = vim.api.nvim_get_current_win()
  local target = require("setup.quickfix").find_target_window(build_win)
  if not target then
    vim.notify("build: no suitable window to open the location in", vim.log.levels.WARN)
    return
  end
  -- a float would cover the location, a split can stay open like quickfix
  if vim.api.nvim_win_get_config(build_win).relative ~= "" then
    M.close()
  end
  vim.api.nvim_set_current_win(target)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  local last = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0, { math.min(lnum, last), math.max(col - 1, 0) })
  vim.cmd("normal! zz")
end

function M.has_active_job(opts)
  if M.job_running then
    log.error("A CMake task is already running: " .. M.cmd .. " Stop it before trying to run a new CMake task.")
    return true
  end
  return false
end

function M.stop(opts)
  if M.term and M.job_running then
    vim.fn.jobstop(M.term.job_id)
    M.job_running = false
    M.cmd = nil
  end
end

function M.is_installed()
  return true
end

-- Show/hide the build output, using the configured executor options.
-- `direction` overrides the configured one, e.g. "float".
function M.toggle(direction)
  if not M.term then
    vim.notify("build: no build has run yet", vim.log.levels.INFO)
  elseif is_open() then
    M.close()
  else
    M.show(vim.tbl_extend("force", M.opts, { direction = direction or M.opts.direction }))
  end
end

-- Statusline text, e.g. "⠹ 42%", "✓", "✗"; nil before the first build.
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
function M.status()
  if M.state == "running" then
    local frame = spinner[math.floor(vim.uv.hrtime() / 1e8) % #spinner + 1]
    return frame .. (M.progress and (" " .. M.progress) or "")
  elseif M.state == "success" then
    return "✓"
  elseif M.state == "failed" then
    return "✗"
  end
end

-- True if a toggleterm window other than the build terminal is open.
function M.other_terminal_open()
  local open = require("toggleterm.ui").find_open_windows(function(buf)
    local id = vim.b[buf].toggle_number
    return id ~= nil and id ~= M.ID
  end)
  return open
end

return M

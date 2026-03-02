local M = {}

local project_root_markers = {
  'uv.lock',
  'pyproject.toml',
  'go.work',
  'go.mod',
  'package.json',
  '.git',
}

local state = { win = nil, buf = nil, chan = nil }

local function resolve_project_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    return vim.fn.getcwd()
  end
  return vim.fs.root(bufname, project_root_markers) or vim.fn.getcwd()
end

local function is_term_open()
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function apply_window_tweaks(win)
  local window_opts = {
    number = false,
    relativenumber = false,
    signcolumn = 'no',
    cursorline = false,
    foldcolumn = '0',
    winfixheight = true,
  }
  for opt, value in pairs(window_opts) do
    pcall(vim.api.nvim_win_set_option, win, opt, value)
  end
end

local function launch_terminal(extra_args)
  vim.cmd 'botright split'
  vim.cmd 'resize 16'
  local win = vim.api.nvim_get_current_win()
  apply_window_tweaks(win)

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, 'buflisted', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local args = { 'codex' }
  if extra_args and extra_args ~= '' then
    vim.list_extend(args, vim.split(extra_args, '%s+', { trimempty = true }))
  end
  vim.fn.termopen(args, { cwd = resolve_project_root() })

  state.win = win
  state.buf = buf
  state.chan = vim.b[buf].terminal_job_id
  vim.cmd 'startinsert'
end

function M.open(extra_args)
  if not vim.fn.executable 'codex' then
    vim.notify('`codex` not found on PATH', vim.log.levels.ERROR)
    return
  end
  if is_term_open() then
    vim.api.nvim_set_current_win(state.win)
    return
  end
  launch_terminal(extra_args)
end

function M.close()
  if not is_term_open() then
    return
  end
  vim.api.nvim_win_close(state.win, true)
  state = { win = nil, buf = nil, chan = nil }
end

function M.focus()
  if is_term_open() then
    vim.api.nvim_set_current_win(state.win)
  end
end

function M.toggle(extra_args)
  if is_term_open() then
    M.close()
  else
    M.open(extra_args)
  end
end

function M.restart(extra_args)
  M.close()
  M.open(extra_args)
end

function M.send(text)
  if not text or text == '' then
    return
  end
  M.open()
  if state.chan then
    vim.api.nvim_chan_send(state.chan, text)
  end
end

function M.send_selection()
  local start_mark = vim.api.nvim_buf_get_mark(0, '<')
  local end_mark = vim.api.nvim_buf_get_mark(0, '>')
  if start_mark[1] == 0 or end_mark[1] == 0 then
    vim.notify('No selection to send', vim.log.levels.WARN)
    return
  end
  local lines = vim.api.nvim_buf_get_text(
    0,
    start_mark[1] - 1,
    start_mark[2],
    end_mark[1] - 1,
    end_mark[2] + 1,
    {}
  )
  if vim.tbl_isempty(lines) then
    return
  end
  M.send(table.concat(lines, '\n') .. '\n')
end

function M.setup()
  local group = vim.api.nvim_create_augroup('codex-terminal', { clear = true })
  vim.api.nvim_create_user_command('Codex', function(opts)
    M.toggle(opts.args)
  end, {
    nargs = '*',
    desc = 'Toggle Codex terminal',
    force = true,
  })
  vim.api.nvim_create_user_command('CodexOpen', function(opts)
    M.open(opts.args)
  end, { nargs = '*', desc = 'Open Codex terminal', force = true })
  vim.api.nvim_create_user_command('CodexClose', function()
    M.close()
  end, { desc = 'Close Codex terminal', force = true })
  vim.api.nvim_create_user_command('CodexFocus', function()
    M.focus()
  end, { desc = 'Focus Codex terminal', force = true })
  vim.api.nvim_create_user_command('CodexRestart', function(opts)
    M.restart(opts.args)
  end, { nargs = '*', desc = 'Restart Codex terminal', force = true })
  vim.api.nvim_create_user_command('CodexSendSelection', function()
    M.send_selection()
  end, { desc = 'Send visual selection to Codex', force = true })

  vim.keymap.set('n', '<leader>ac', function()
    M.toggle()
  end, { desc = 'Toggle [A]I [C]odex' })
  vim.keymap.set('n', '<leader>af', function()
    M.focus()
  end, { desc = '[A]I [F]ocus Codex' })
  vim.keymap.set('n', '<leader>ar', function()
    M.restart()
  end, { desc = '[A]I [R]estart Codex' })
  vim.keymap.set('x', '<leader>as', function()
    M.send_selection()
  end, { desc = '[A]I Send selection', silent = true })
end

return M

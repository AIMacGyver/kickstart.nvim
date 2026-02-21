local M = {}

local is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
local path_sep = is_windows and '\\' or '/'
local path_delim = is_windows and ';' or ':'

local function join_path(...)
  return table.concat({ ... }, path_sep)
end

function M.get_root_from_path(path)
  if path == nil or path == '' then
    return nil
  end
  return vim.fs.root(path, { 'uv.lock', 'pyproject.toml', '.git' })
end

function M.get_root(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr or 0)
  return M.get_root_from_path(bufname)
end

function M.get_python(root_dir)
  if root_dir == nil or root_dir == '' then
    return nil
  end

  local python_path
  if is_windows then
    python_path = join_path(root_dir, '.venv', 'Scripts', 'python.exe')
  else
    python_path = join_path(root_dir, '.venv', 'bin', 'python')
  end

  if vim.fn.executable(python_path) == 1 then
    return python_path
  end

  return nil
end

function M.get_cmd_env(root_dir)
  local python_path = M.get_python(root_dir)
  if not python_path then
    return nil
  end

  local bin_dir = vim.fs.dirname(python_path)
  local venv_dir = vim.fs.dirname(bin_dir)
  return {
    VIRTUAL_ENV = venv_dir,
    UV_PROJECT_ENVIRONMENT = venv_dir,
    PATH = bin_dir .. path_delim .. (vim.env.PATH or ''),
  }
end

function M.apply_cmd_env(new_config, root_dir)
  local cmd_env = M.get_cmd_env(root_dir)
  if not cmd_env then
    return
  end
  new_config.cmd_env = vim.tbl_deep_extend('force', new_config.cmd_env or {}, cmd_env)
end

function M.setup()
  local group = vim.api.nvim_create_augroup('custom-python-uv', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    group = group,
    callback = function(args)
      local root = M.get_root(args.buf)
      if not root then
        vim.b[args.buf].uv_project_root = nil
        vim.b[args.buf].uv_python = nil
        return
      end

      vim.b[args.buf].uv_project_root = root
      vim.b[args.buf].uv_python = M.get_python(root)
    end,
  })

  vim.api.nvim_create_user_command('UvPythonInfo', function()
    local root = M.get_root(0)
    if not root then
      vim.notify('No uv/python project root detected for current buffer', vim.log.levels.INFO)
      return
    end

    local python_path = M.get_python(root)
    local lines = {
      'uv project root: ' .. root,
      'python interpreter: ' .. (python_path or 'not found at .venv'),
    }
    vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
  end, {
    desc = 'Show uv project root and interpreter for current buffer',
    force = true,
  })
end

return M

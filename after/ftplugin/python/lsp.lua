-- Important to install debugpy (dap provided by microsoft) within a virtual environment for this work:
-- python -m venv venv
-- venv/bin/python -m pip install debugpy

local function path_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function executable(path)
  return path_exists(path) and vim.fn.executable(path) == 1
end

local function find_python_root()
  local file_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  local root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'tox.ini',
    'pytest.ini',
    'manage.py',
    '.git',
  }
  local root = vim.fs.root(file_dir, root_markers)

  if root and root ~= vim.env.HOME then
    return root
  end

  return vim.fn.getcwd()
end

local function venv_python(venv_dir)
  local python = venv_dir .. '/bin/python'

  if executable(python) then
    return python
  end
end

local function find_venv_python(root)
  local venv_names = vim.g.python_venv_names or { '.venv', 'venv', '.env', 'env' }

  for _, name in ipairs(venv_names) do
    local python = venv_python(root .. '/' .. name)

    if python then
      return python
    end
  end

  local handle = vim.uv.fs_scandir(root)

  if not handle then
    return
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)

    if not name then
      return
    end

    if type == 'directory' and path_exists(root .. '/' .. name .. '/pyvenv.cfg') then
      local python = venv_python(root .. '/' .. name)

      if python then
        return python
      end
    end
  end
end

local function python_path()
  if vim.env.VIRTUAL_ENV then
    local python = venv_python(vim.env.VIRTUAL_ENV)

    if python then
      return python
    end
  end

  local roots = { vim.fn.getcwd(), find_python_root() }
  local seen = {}

  for _, root in ipairs(roots) do
    if root and root ~= '' and not seen[root] then
      seen[root] = true
      local python = find_venv_python(root)

      if python then
        return python
      end
    end
  end

  return vim.fn.exepath 'python3'
end

local function module_path_from_root()
  local root = find_python_root()
  local file = vim.api.nvim_buf_get_name(0)
  local relpath = vim.fs.relpath(root, file)

  if not relpath then
    relpath = file

    if vim.startswith(file, root .. '/') then
      relpath = file:sub(#root + 2)
    end
  end

  relpath = relpath:gsub('%.py$', '')
  local module_path = relpath:gsub('/', '.')
  return module_path
end

local function python_test_config(config)
  return vim.tbl_extend('force', config, {
    cwd = find_python_root(),
    pythonPath = python_path(),
    justMyCode = false,
  })
end

local function neotest_debug_nearest()
  local ok, neotest = pcall(require, 'neotest')

  if not ok then
    return false
  end

  neotest.run.run {
    strategy = 'dap',
    suite = false,
  }

  return true
end

local function neotest_debug_class(dap_python)
  local ok, neotest = pcall(require, 'neotest')

  if not ok then
    return false
  end

  local class_nodes = dap_python._get_nodes(0, 'class')

  if not class_nodes or not class_nodes[1] then
    return false
  end

  local class_names = vim.tbl_map(function(node)
    return vim.treesitter.get_node_text(node, 0)
  end, class_nodes)

  neotest.run.run {
    vim.api.nvim_buf_get_name(0) .. '::' .. table.concat(class_names, '::'),
    strategy = 'dap',
    suite = false,
  }

  return true
end

local function neotest_debug_file()
  local ok, neotest = pcall(require, 'neotest')

  if not ok then
    return false
  end

  neotest.run.run {
    vim.api.nvim_buf_get_name(0),
    strategy = 'dap',
  }

  return true
end

local function debugger()
  local dap = require 'dap'
  local dap_python = require 'dap-python'

  if not vim.g.python_dap_configured then
    dap_python.setup(python_path(), {
      console = 'integratedTerminal',
    })

    dap_python.test_runner = 'unittest'
    dap_python.test_runners.unittest = function(classnames, methodname)
      local parts = { module_path_from_root() }

      if type(classnames) == 'table' then
        vim.list_extend(parts, classnames)
      elseif classnames then
        table.insert(parts, classnames)
      end

      if methodname then
        table.insert(parts, methodname)
      end

      local test_path = table.concat(parts, '.')

      return 'unittest', { '-v', test_path }
    end

    vim.g.python_dap_configured = true
  end

  local opts = { buffer = true }
  vim.keymap.set('n', '<leader>dm', function()
    if neotest_debug_nearest() then
      return
    end

    dap_python.test_method {
      test_runner = 'unittest',
      config = python_test_config,
    }
  end, vim.tbl_extend('force', opts, { desc = '[D]ebug: Test nearest [m]ethod' }))

  vim.keymap.set('n', '<leader>dc', function()
    if neotest_debug_class(dap_python) then
      return
    end

    dap_python.test_class {
      test_runner = 'unittest',
      config = python_test_config,
    }
  end, vim.tbl_extend('force', opts, { desc = '[D]ebug: Test nearest [c]lass' }))

  vim.keymap.set('n', '<leader>df', function()
    if neotest_debug_file() then
      return
    end

    dap.run {
      type = 'python',
      request = 'launch',
      name = 'Python: current file',
      program = '${file}',
      cwd = find_python_root(),
      pythonPath = python_path(),
      console = 'integratedTerminal',
      justMyCode = false,
    }
  end, vim.tbl_extend('force', opts, { desc = '[D]ebug: Python [f]ile' }))

  vim.keymap.set('v', '<leader>ds', function()
    dap_python.debug_selection {
      config = python_test_config,
    }
  end, vim.tbl_extend('force', opts, { desc = '[D]ebug: Python [s]election' }))
end

debugger()

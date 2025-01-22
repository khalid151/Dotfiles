local dap = require("dap")

-- C
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
       local name = vim.fn.input('Executable name (filter): ')
       return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  },
}

-- C++
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

local dap = require("dap")

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-dap',
    name = 'lldb',
}

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

load_script("switch_sink.lua", {
  match = { "node.name", "equals", "telegram-desktop" },
  sink = { "node.name", "equals", "alsa_output.pci-0000_0a_00.4.analog-stereo" },
})

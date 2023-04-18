local name_rules = {
  {
    matches = {
      {
        { "node.name", "equals", "alsa_output.pci-0000_08_00.1.hdmi-stereo" },
      },
    },
    apply_properties = {
      ["node.description"] = "Speakers",
    },
  },
  {
    matches = {
      {
        { "node.name", "equals", "alsa_output.pci-0000_0a_00.4.analog-stereo" },
      },
    },
    apply_properties = {
      ["node.description"] = "Headphones",
    },
  },
  {
    matches = {
      {
        { "node.name", "equals", "alsa_input.usb-0c76_USB_PnP_Audio_Device-00.pro-input-0" },
      },
    },
    apply_properties = {
      ["node.description"] = "Microphone",
    },
  },
}

for i, rule in pairs(name_rules) do
  table.insert(alsa_monitor.rules, rule)
end

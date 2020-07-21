local beautiful = require("beautiful")
local screen_geometry = require("awful").screen.focused().geometry
local hotkeys_popup = require("awful.hotkeys_popup.widget").new()

hotkeys_popup:_load_widget_settings()
hotkeys_popup.merge_duplicates = true
hotkeys_popup.width = beautiful.hotkeys_width or screen_geometry.width * 0.9
hotkeys_popup.height = beautiful.hotkeys_height or screen_geometry.height * 0.9

return hotkeys_popup

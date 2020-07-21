local wibox = require("wibox")
local gears = require("gears")
local signal = require("widgets.signal")

local widgets = {
    battery = require("widgets.battery"),
    brightness = require("widgets.brightness"),
    confirm_dialogue = require("widgets.confirm_dialogue"),
    imagebox_button = require("widgets.imagebox_button"),
    hotkeys_popup = require("widgets.hotkeys_popup"),
    popup_menu = require("widgets.popup_menu"),
    scrollbox = require("widgets.scrollbox"),
    separator = require("widgets.separator"),
    space = wibox.widget.textbox(" "),
    systray = require("widgets.systray"),
    tasks_launcher_combo = require("widgets.tasks_launcher_combo"),
    textclock = require("widgets.textclock"),
    titlebar = require("widgets.titlebar"),
    toggle_widget = require("widgets.toggle_widget"),
    volume = require("widgets.volume"),
    taglist = require("widgets.taglist"),
}

-- Update widgets
gears.timer {
    timeout = 2,
    autostart = true,
    call_now = true,
    callback = function()
        signal.update("battery")
        signal.update("brightness")
        signal.update("volume")
    end
}

-- Signal functions
widgets.connect_signal = function(...) signal.connect_signal(...) end
widgets.emit_signal = function(...) signal.emit_signal(...) end
widgets.update = function(...) signal.update(...) end

return widgets

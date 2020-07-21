local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local signal = {}
local global_signal_widget = wibox.widget{}

-- Call this function to update specific widgets on demand
signal.update = function(name)
    global_signal_widget:emit_signal("widget::" .. name)
end

signal.connect_signal = function(signal, ...)
    global_signal_widget:connect_signal(signal, ...)
end

signal.emit_signal = function(signal, ...)
    global_signal_widget:emit_signal(signal, ...)
end

return signal

local wibox = require("wibox")
local beautiful = require("beautiful")

return function(args)
    args.format = args.format or "%I:%M %p"
    args.font = args.font or beautiful.font

    local widget = wibox.widget {
        font = args.font,
        format = args.format,
        widget = wibox.widget.textclock
    }

    widget:connect_signal("button::press", function(w)
        -- TODO: add popup for calendar
    end)

    return widget
end

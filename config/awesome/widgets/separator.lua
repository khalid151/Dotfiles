local wibox = require("wibox")
local beautiful = require("beautiful")

return function(args)
    return wibox.widget {
        {
            color = args.color,
            opacity = 0.5,
            forced_width = args.thickness or 1,
            forced_height = beautiful.bar_height - 22,
            thickness = args.thickness or 1,
            widget = wibox.widget.separator,
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
        visible = args.visible,
    }
end

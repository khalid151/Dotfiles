local wibox = require("wibox")
local toggle_widget = require("widgets.toggle_widget")

return function(args)
    local systray = wibox.widget.systray()
    systray.base_size = args.base_size or 25
    if args.append_seperator then
        args['widget'] = wibox.widget {
            systray,
            require("widgets.separator"){ color = args.separator_color },
            wibox.widget.textbox(' '),
            layout = wibox.layout.fixed.horizontal,
        }
    else
        args['widget'] = systray
    end
    args['toggle_bg'] = true
    return toggle_widget(args)
end

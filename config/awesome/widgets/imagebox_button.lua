local wibox = require("wibox")

return function(args)
    local widget = wibox.widget {
        image = args.image,
        resize = args.resize,
        forced_height = args.forced_height,
        forced_width = args.forced_width,
        widget = wibox.widget.imagebox
    }

    widget:connect_signal("button::press", function(w, _, _, button)
        if button == 1 then
            if args.click_image then
                w.image = type(args.click_image) == "function" and args.click_image() or args.click_image
            elseif args.use_opacity then
                w.opacity = 0.7
                w:emit_signal("widget::redraw_needed")
            end
        end
    end)
    widget:connect_signal("button::release", function(w, _, _, button)
        if button == 1 then
            if args.click_image then
                w.image = type(args.hover_image) == "function" and args.hover_image() or args.hover_image
            elseif args.use_opacity then
                w.opacity = 1
                w:emit_signal("widget::redraw_needed")
            end
            args.action()
            w:emit_signal("mouse::enter")
        end
    end)
    widget:connect_signal("mouse::enter", function(w)
        if args.hover_image then
            w.image = type(args.hover_image) == "function" and args.hover_image() or args.hover_image
        elseif args.use_opacity then
            w.opacity = 0.7
            w:emit_signal("widget::redraw_needed")
        end
    end)
    widget:connect_signal("mouse::leave", function(w)
        if args.hover_image then
            w.image = type(args.image) == "function" and args.image() or args.image
        elseif args.use_opacity then
            w.opacity = 1
            w:emit_signal("widget::redraw_needed")
        end
    end)

    return widget
end

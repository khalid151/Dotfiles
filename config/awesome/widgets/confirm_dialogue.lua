local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

return function(args)
    args.bg = args.bg or beautiful.menu_bg_normal or beautiful.bg_normal
    args.highlight = args.highlight or beautiful.menu_bg_focus or beautiful.bg_focus
    local image = {
        Yes = args.yes_image,
        No = args.no_image,
    }
    local buttons = wibox.widget {
        {
            {
                {
                    wibox.widget.imagebox(args.recolor_image and gears.color.recolor_image(image.Yes, args.fg) or image.Yes),
                    margins = args.image_margins,
                    widget = wibox.container.margin,
                },
                {
                    text = "Yes",
                    font = args.font,
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            buttons = awful.button({}, 1, args.action),
            widget = wibox.container.background,
        },
        {
            {
                {
                    wibox.widget.imagebox(args.recolor_image and gears.color.recolor_image(image.No, args.fg) or image.No),
                    margins = args.image_margins,
                    widget = wibox.container.margin,
                },
                {
                    text = "No",
                    font = args.font,
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            widget = wibox.container.background,
        },
        layout = wibox.layout.fixed.horizontal,
    }

    for _,widget in ipairs(buttons.children) do
        local icon = widget.widget.children[1]
        local text = widget.widget.children[2].text
        widget:connect_signal("mouse::enter", function(w)
            w.bg = args.highlight
            w.fg = args.bg
            if args.recolor_image then
                icon.image = gears.color.recolor_image(image[text], w.fg)
            end
        end)
        widget:connect_signal("mouse::leave", function(w)
            w.bg = "transparent"
            w.fg = args.fg
            if args.recolor_image then
                icon.image = gears.color.recolor_image(image[text], w.fg)
            end
        end)
        widget.forced_height = args.height or beautiful.menu_height
        widget.forced_width = args.width or beautiful.menu_width
        widget.fg = args.fg
    end

    local popup = awful.popup {
        widget = {
            {
                {
                    {
                        text = args.text or "Are you sure?",
                        align = 'center',
                        valign = 'center',
                        font = args.font,
                        widget = wibox.widget.textbox,
                    },
                    fg = args.fg,
                    forced_height = args.height or beautiful.menu_height,
                    forced_width = args.width or beautiful.menu_width,
                    widget = wibox.container.background,
                },
                buttons,
                widget = wibox.layout.fixed.vertical,
            },
            bg = args.bg,
            widget = wibox.container.background,
        },
        bg = args.bg or "transparent",
        shape = args.shape,
        visible = args.visible,
        ontop = true,
        x = args.x,
        y = args.y,
        placement = args.placement or awful.placement.under_mouse,
    }

    local hide_timer = gears.timer {
        single_shot = true,
        timeout = 0.5,
        callback = function() popup.visible = false end
    }

    popup:connect_signal("button::release", function() popup.visible = false end)
    popup:connect_signal("mouse::enter", function() if hide_timer.started then hide_timer:stop() end end)
    popup:connect_signal("mouse::leave", function() if not hide_timer.started then hide_timer:start() end end)

    return popup
end

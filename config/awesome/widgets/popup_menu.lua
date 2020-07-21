local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

return function(args)
    -- TODO: add keyboard selection
    local widgets = {}
    for _,entry in ipairs(args.entries) do
        local widget = wibox.widget {
            {
                {
                    image = entry.image,
                    highlight_image = entry.highlight_image,
                    widget = wibox.widget.imagebox,
                },
                {
                    text = entry.text,
                    font = args.font,
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            forced_height = args.height or beautiful.menu_height,
            forced_width = args.width or beautiful.menu_width,
            spacing = 2,
            fg = args.fg,
            highlight_fg = args.highlight_fg,
            widget = wibox.container.background,
        }
        widget:connect_signal("button::press", entry.action)
        widget:connect_signal("mouse::enter", function(w)
            w.bg = args.highlight
            if w.highlight_fg then
                w.fg, w.highlight_fg = w.highlight_fg, w.fg
            end
            local icon = w.widget.children[1]
            if entry.recolor_image then
                icon.image = gears.color.recolor_image(entry.image, w.fg)
            end
        end)
        widget:connect_signal("mouse::leave", function(w)
            w.bg = "transparent"
            if w.highlight_fg then
                w.fg, w.highlight_fg = w.highlight_fg, w.fg
            end
            local icon = w.widget.children[1]
            if entry.recolor_image then
                icon.image = gears.color.recolor_image(entry.image, w.fg)
            end
        end)
        widgets[_] = widget
    end
    widgets['layout'] = wibox.layout.fixed.vertical

    local popup = awful.popup {
        height = args.height,
        widget = widgets,
        bg = args.bg or "transparent",
        shape = args.shape,
        visible = false,
        ontop = true,
        x = args.x,
        y = args.y,
        placement = args.placement,
    }

    -- To hide popup
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

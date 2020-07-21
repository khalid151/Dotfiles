-- TODO: fix notification sizing
local naughty = require("naughty")
local beautiful = require("beautiful")

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local widgets = require("widgets")
local ruled = require("ruled")

-- Config
naughty.config.padding = beautiful.notification_padding
naughty.config.defaults.padding = beautiful.notification_padding
naughty.config.defaults.icon_size = beautiful.notification_icon_size
naughty.config.defaults.max_width = beautiful.notification_width
naughty.config.defaults.width = beautiful.notification_width
naughty.config.defaults.height = beautiful.notification_height
naughty.config.defaults.position = beautiful.notification_position

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- Create a function so it can be reused later for other templates
local generate_actions_template = function(fg, bg, vertical)
    return {
        widget = naughty.list.actions,
        style = {
            underline_normal = false,
            underline_selected = false,
        },
        base_layout = wibox.widget {
            spacing = 5,
            layout = wibox.layout.flex[vertical and 'vertical' or 'horizontal'],
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        align = 'center',
                        widget = wibox.widget.textbox,
                    },
                    margins = 5,
                    widget = wibox.container.margin,
                },
                widget = wibox.container.background,
                bg = bg,
                fg = fg,
                shape = beautiful.rounded_rect,
            },
            margins = 5,
            widget = wibox.container.margin,
        },
    }
end

local generate_template = function(args)
    return {
        {
            {
                {
                    {
                        {
                            {
                                resize_strategy = 'scale',
                                image = args.icon, -- If this template was reused
                                widget = args.icon and wibox.widget.imagebox or naughty.widget.icon,
                            },
                            forced_height = 48,
                            forced_width = 48,
                            widget = wibox.container.background,
                        },
                        margins = 7,
                        right = 0,
                        widget = wibox.container.margin,
                    },
                    {
                        {
                            {
                                font = args.font,
                                text = args.title,
                                widget = wibox.widget.textbox,
                            },
                            {
                                font = beautiful.notification_font,
                                text = args.message,
                                widget = args.message and wibox.widget.textbox or naughty.widget.message,
                            },
                            widgets.space,
                            layout = wibox.layout.fixed.vertical,
                        },
                        fg = args.fg,
                        widget = wibox.container.background,
                    },
                    spacing = 6,
                    layout = wibox.layout.fixed.horizontal,
                },
                nil,
                {
                    generate_actions_template(args.bg, args.fg .. 'de'),
                    left = 15,
                    right = 15,
                    widget = wibox.container.margin
                },
                spacing = 10,
                layout = wibox.layout.align.vertical
            },
            id = 'background_role',
            widget = wibox.container.background,
        },
        width = beautiful.notification_width,
        forced_width = beautiful.notification_width,
        widget = wibox.container.constraint,
    }
end

-- RULES ----------------------------------------------------------------------
ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule {
        rule = {},
        properties = {
            timeout = 5,
            hover_timeout = 0,
            bg = beautiful.notification_bg_normal,
            fg = beautiful.notification_fg_normal,
            border_width = beautiful.notification_border_width,
            callback = function(n)
                n.store = true
                n.icon = n:get_icon() or beautiful.notification_default_icon
            end
        }
    }
    ruled.notification.append_rule {
        rule = { app_name = "gopass" },
        properties = {
            callback = function(n)
                n.store = false
            end
        }
    }
    ruled.notification.append_rule {
        rule = { urgency = 'critical' },
        properties = {
            bg = beautiful.notification_bg_critical,
            fg = beautiful.notification_fg_critical,
            timeout = 0,
            callback = function(n)
                n.store = false
                n.icon = n:get_icon() or beautiful.notification_error_icon
            end
        }
    }
    ruled.notification.append_rule {
        rule = { app_name = "scrot" },
        properties = {
            store = false,
            callback = function(n)
                n.widget_template = {
                    {
                        {
                            {
                                resize_strategy = 'scale',
                                image = n.icon,
                                widget = wibox.widget.imagebox,
                            },
                            {
                                nil,
                                nil,
                                {
                                    {
                                        {
                                            {
                                                image = beautiful.icons['24x24']['camera'],
                                                forced_height = 20,
                                                widget = wibox.widget.imagebox,
                                            },
                                            wibox.widget.textbox("Screenshot taken"),
                                            spacing = 5,
                                            layout = wibox.layout.fixed.horizontal,
                                        },
                                        margins = 5,
                                        widget = wibox.container.margin,
                                    },
                                    bg = beautiful.notification_fg_normal .. "ce",
                                    widget = wibox.container.background,
                                },
                                layout = wibox.layout.align.vertical,
                            },
                            layout = wibox.layout.stack,
                        },
                        input_passthrough = true,
                        id = 'background_role',
                        widget = wibox.container.background,
                    },
                    width = beautiful.notification_width,
                    forced_width = beautiful.notification_width,
                    widget = wibox.container.constraint,
                }
            end
        }
    }
end)

naughty.connect_signal('request::display', function(n)
    naughty.layout.box {
        notification = n,
        widget_template = n.widget_template or generate_template {
            font = beautiful.notification_font_title,
            fg = n:get_fg(),
            title = n:get_title(),
        },
        shape = beautiful.rounded_rect,
    }
end)

-- NOTIFICATION CENTER --------------------------------------------------------
-- Notifications will be stored here, in a scrollbox widget
local storage = widgets.scrollbox {
    height = 100,
    width = beautiful.notification_width + 10,
    append_widgets = false,
}

local notification_center = awful.popup {
    widget = {
        storage,
        forced_height = 500,
        forced_width = beautiful.notification_width + 10,
        widget = wibox.container.background,
    },
    bg = beautiful.notification_center_bg,
    visible = false,
    ontop = true,
    shape = beautiful.rounded_rect,
}
awful.placement.top_right(notification_center, {
        margins = 5,
        offset = {
            x = -1 * beautiful.notification_width - 10,
            y = beautiful.bar_height,
        }
    })

widgets.connect_signal("notifications::toggle_center", function()
    notification_center.visible = not notification_center.visible
end)

widgets.connect_signal("notifications::hide_center", function()
    notification_center.visible = false
end)

widgets.connect_signal("notifications::clear", function()
    if notification_center.visible then
        storage:set_children({})
        storage:emit_signal("widget::redraw_needed")
        widgets.emit_signal("notifications::count_change", #storage:get_children())
    end
end)

storage:connect_signal("widget::removed", function()
    -- Whenever a widget is deleted, check notifcations
    widgets.emit_signal("notifications::count_change", #storage:get_children())
end)

naughty.connect_signal("added", function(n)
    -- Do not add if it's a screenshot notification, or music player one or urgent
    local store_notification = function()
        local time = wibox.widget.textbox()
        awful.spawn.easy_async("date +'%I:%M %p'", function(o) time.text = o end)
        local dismiss = wibox.widget {
            {
                text = "",
                font = beautiful.font_name .. ' 15',
                widget = wibox.widget.textbox,
            },
            fg = "red",
            widget = wibox.container.background,
            visible = false,
            buttons = awful.button({}, 1, function()
                storage:remove_widget(storage:get_widget_by_id(n:get_id()))
            end)
        }
        if n.store and not n.is_destroyed then
            local noti = wibox.widget {
                {
                    {
                        generate_template {
                            icon = n:get_icon() or beautiful.notification_default_icon,
                            title = n:get_title(),
                            message = n:get_message(),
                            font = "Teko 12",
                            fg = beautiful.notification_fg_normal,
                            bg = beautiful.notification_bg_normal,
                        },
                        {
                            {
                                {
                                    {
                                        time,
                                        wibox.container.margin(dismiss, 0, 0, -5),
                                        layout = wibox.layout.stack,
                                    },
                                    shape = beautiful.rounded_rect,
                                    bg = beautiful.notification_bg_normal .. "de",
                                    widget = wibox.container.background,
                                },
                                top = 2,
                                right = 5,
                                widget = wibox.container.margin,
                            },
                            valign = 'top',
                            halign = 'right',
                            widget = wibox.container.place,
                        },
                        layout = wibox.layout.stack,
                    },
                    bg = beautiful.notification_bg_normal,
                    fg = beautiful.notification_fg_normal,
                    forced_height = beautiful.notification_height,
                    height = beautiful.notification_height,
                    widget = wibox.container.background,
                    shape = beautiful.rounded_rect,
                },
                widget = wibox.container.margin,
                margins = 5,
            }
            noti.id = n:get_id()
            storage:add_widget(noti)
            widgets.emit_signal("notifications::count_change", #storage:get_children())
            noti:connect_signal("mouse::enter", function() time.visible = false; dismiss.visible = true end)
            noti:connect_signal("mouse::leave", function() dismiss.visible = false; time.visible = true end)
        end
    end

    gears.timer {
        autostart = true,
        single_shot = true,
        timeout = n.timeout,
        callback = store_notification,
    }
end)

naughty.connect_signal("destroyed", function(n, context)
    if context ~= 1 then
        n.is_destroyed = true
        local w = storage:get_widget_by_id(n:get_id())
        storage:remove_widget(w)
        widgets.emit_signal("notifications::count_change", #storage:get_children())
    end
end)

return naughty

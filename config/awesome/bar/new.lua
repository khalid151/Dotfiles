local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local keys = require("keys")
local widgets = require("widgets")
local helper = require("helper")
local animation = require("awesome-AnimationFramework/Animation")

-- TODO: create a layoutbox widget + create their icons
screen.connect_signal("request::desktop_decoration", function(s)
    -- Widgets
    local textclock = widgets.textclock{format = "%a %b %d, %I:%M %p", font = beautiful.font_name .. "9"}
    local volume = widgets.volume
    local brightness = widgets.brightness
    local battery = widgets.battery
    battery.text.visible = true
    battery:update_text_spacing(5)
    local taglist = widgets.taglist {
        screen = s,
        active = "#ffffff",
        inactive = "#c4c4c4",
    }
    taglist.opacity = 0

    -- Confirm dialogues for reboot and poweroff
    local confirm_dialogues = {}
    for _,action in ipairs {'reboot', 'poweroff'} do
        confirm_dialogues[action] = widgets.confirm_dialogue {
            action = function() awful.spawn("systemctl " .. action) end,
            text = string.format("Confirm %s?", action),
            font = "Teko 10",
            bg = "#d3d3d3",
            highlight = "#333333",
            fg = "#333333",
            width = 60,
            height = 25,
            image_margins = 5,
            placement = awful.placement.top_right,
            yes_image = "/usr/share/icons/Papirus/22x22/emblems/vcs-normal.svg",
            no_image = "/usr/share/icons/Papirus/22x22/emblems/vcs-conflicting.svg",
            visible = false,
            shape = beautiful.rounded_rect,
        }
    end

    -- Display and access notification center
    local notification_count_widget = wibox.widget {
        {
            {
                text = '0',
                align = 'center',
                valign = 'center',
                font = beautiful.font_name .. ' 7',
                widget = wibox.widget.textbox,
            },
            bg = beautiful.notification_bg_normal ,
            fg = "black",
            shape = beautiful.rounded_rect,
            forced_width = 14,
            forced_height = 14,
            widget = wibox.container.background,
        },
        valign = 'center',
        widget = wibox.container.place,
        buttons = awful.button({}, 1, function() widgets.emit_signal("notifications::toggle_center") end),
        visible = false,
    }
    widgets.connect_signal("notifications::count_change", function(_, count)
        local widget = notification_count_widget.widget.widget
        if count > 0 then
            widget.text = count
            notification_count_widget.visible = true
        else
            notification_count_widget.visible = false
            widgets.emit_signal("notifications::hide_center")
        end
    end)

    s.bar = awful.wibar {
        screen = s,
        bg = beautiful.bg,
        ontop = beautiful.bar_ontop,
        position = beautiful.bar_position,
        height = beautiful.bar_height
    }
    s.bar:setup {
        {
            widgets.tasks_launcher_combo {
                font = "Teko 10",
                bg = beautiful.fg .. "de",
                fg = beautiful.bg,
                indicator_color = "red",
                screen = s,
                default_tag_icon = beautiful.tag_icon.default,
                buttons = keys.tasklist_buttons,
                shape = beautiful.rounded_rect,
            },
            margins = beautiful.widget_icon_margin + 1,
            widget = wibox.container.margin
        },
        {
            textclock,
            taglist,
            layout = wibox.layout.stack
        },
        {
            {
                {
                    notification_count_widget,
                    --widgets.space,
                    widgets.systray {
                        show_icon = beautiful.arrow_icon_left,
                        hide_icon = beautiful.arrow_icon_right,
                        toggle_bg = true,
                        bg = beautiful.bg_systray,
                        shape = beautiful.rounded_rect,
                    },
                    volume,
                    brightness,
                    battery,
                    widgets.space,
                    widgets.separator("white"),
                    widgets.space,
                    widgets.toggle_widget {
                        show_icon = "/usr/share/icons/ePapirus/24x24/apps/system-users.svg",
                        hide_icon = "/usr/share/icons/ePapirus/24x24/apps/system-log-out.svg",
                        widget = wibox.widget {
                                {
                                    image = "/usr/share/icons/ePapirus/24x24/apps/system-lock-screen.svg",
                                    widget = wibox.widget.imagebox,
                                },
                                widgets.imagebox_button {
                                    action = function()
                                        local c = confirm_dialogues.reboot
                                        awful.placement.top_right(c, {
                                                margins = 5,
                                                offset = { y = beautiful.bar_height },
                                            })
                                        c.visible = not c.visible
                                    end,
                                    image = "/usr/share/icons/ePapirus/24x24/apps/system-reboot.svg",
                                },
                                widgets.imagebox_button {
                                    action = function()
                                        local c = confirm_dialogues.poweroff
                                        c.visible = not c.visible
                                        awful.placement.top_right(c, {
                                                margins = 5,
                                                offset = { y = beautiful.bar_height },
                                            })
                                    end,
                                    image = "/usr/share/icons/ePapirus/24x24/apps/system-shutdown.svg",
                                },
                                spacing = 2,
                                layout = wibox.layout.fixed.horizontal
                        }
                    },
                    spacing = 2,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = beautiful.widget_icon_margin + 3,
                widget = wibox.container.margin
            },
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,

        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    }

    -- Handle tag animations this way
    local tags_animation_widget = wibox.widget { fade = 0, clock_visible = true }
    local tags_animation = animation {
        subject = tags_animation_widget,
        duration = 0.325,
        target = { fade = 1 },
        easing = 'inOutCubic',
    }
    local tag_timer = gears.timer {
        timeout = 2,
        single_shot = true,
        callback = function()
            textclock.fade = 0
            taglist.fade = 1
            tags_animation:startAnimation()
        end
    }
    tag.connect_signal("property::tag_changed", function()
        if textclock.fade == 1 and taglist.fade == 0 then return end
        textclock.fade = 1
        taglist.fade = 0
        tags_animation:startAnimation()
        tag_timer:again()
    end)
    tags_animation:connect_signal('anim::animation_updated', function (w, delta)
        textclock.visible = false
        taglist.visible = false
        textclock.opacity = math.abs(textclock.fade - tags_animation_widget.fade)
        taglist.opacity = math.abs(taglist.fade - tags_animation_widget.fade)
        textclock.visible = true
        taglist.visible = true
    end)
    tags_animation:connect_signal("anim::animation_finished", function()
        tags_animation_widget.fade = 0
    end)
end)

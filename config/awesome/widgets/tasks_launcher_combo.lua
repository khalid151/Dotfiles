local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local confirm_dialogue = require("widgets.confirm_dialogue")
local separator = require("widgets.separator")
local popup_menu = require("widgets.popup_menu")
local space = wibox.widget.textbox(" ")
local hotkeys_popup = require("widgets.hotkeys_popup")

return function(args)
    local focused_task = awful.widget.tasklist {
        screen = args.screen,
        filter = awful.widget.tasklist.filter.focused,
        buttons = args.buttons,
        widget_template = {
            {
                {
                    {
                        id     = 'clienticon',
                        widget = awful.widget.clienticon,
                    },
                    {
                        {
                            {
                                id = "title_role",
                                font = args.font,
                                valign = 'center',
                                widget = wibox.widget.textbox
                            },
                            fg = args.fg,
                            widget = wibox.container.background
                        },
                        top = 1,
                        widget = wibox.container.margin
                    },
                    spacing = 2,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = beautiful.widget_icon_margin - 2,
                widget = wibox.container.margin
            },
            create_callback = function(self, c, index, clientlist)
                self:get_children_by_id('clienticon')[1].client = c
                self:get_children_by_id('title_role')[1].text = c.class or "Unknown"
            end,
            update_callback = function(self, c, index, clientlist)
                self:get_children_by_id('title_role')[1].text = c.class or "Unknown"
            end,
            layout = wibox.layout.align.vertical,
        }
    }

    local tasklist = awful.widget.tasklist {
        screen = args.screen,
        filter = awful.widget.tasklist.filter.alltags,
        buttons = args.buttons,
        layout = {
            spacing = 0,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                id = 'icon_container',
                {
                    {
                        id = 'indicator_highlight',
                        space,
                        bg = "linear:0,0:0,25:0,".. args.indicator_color .. ":1,transparent",
                        visible = false,
                        opacity = 0.2,
                        widget = wibox.container.background
                    },
                    {
                        {
                            id     = 'clienticon',
                            widget = awful.widget.clienticon,
                        },
                        margins = beautiful.widget_icon_margin - 2,
                        widget = wibox.container.margin
                    },
                    {
                        id = 'indicator',
                        {
                            space,
                            --bg = "#705db3",
                            bg = args.indicator_color,
                            forced_height = 25,
                            forced_width = 20,
                            shape = function(cr, w, h) gears.shape.rectangle(cr, 25, 2) end,
                            widget = wibox.container.background
                        },
                        valign = 'top',
                        widget = wibox.container.place
                    },
                    layout = wibox.layout.stack
                },
                bg = "transparent",
                widget = wibox.container.background
            },
            create_callback = function(self, c, index, clientlist)
                local icon = self:get_children_by_id('clienticon')[1]
                icon.client = c
                icon.opacity = icon.client.minimized and 0.5 or 1
                self:get_children_by_id('indicator')[1].visible = c == client.focus
                self:get_children_by_id('indicator_highlight')[1].visible = c == client.focus

                -- Add tooltip for titles
                awful.tooltip {
                    objects = {self:get_children_by_id('icon_container')[1]},
                    mode = 'outside',
                    margins = 5,
                    delay_show = 0.5,
                    preferred_alignments = 'middle',
                    timer_function = function() return c.name end
                }
            end,
            update_callback = function(self, c, index, clientlist)
                self:get_children_by_id('indicator')[1].visible = c == client.focus
                self:get_children_by_id('indicator_highlight')[1].visible = c == client.focus
                local icon = self:get_children_by_id('clienticon')[1]
                icon.visible = false
                icon.opacity = icon.client.minimized and 0.5 or 1
                icon.visible = true
            end,
            layout = wibox.layout.align.vertical,
        }
    }
    tasklist.visible = false

    local tag_task_separator = separator {
        color = args.fg,
        thickness = 1,
        visible = false,
    }

    local tag_icon_launcher = wibox.widget {
        widget = wibox.widget.imagebox,
    }

    local widget = wibox.widget {
        {
            tag_icon_launcher,
            tag_task_separator,
            focused_task,
            tasklist,
            spacing = 2,
            layout = wibox.layout.fixed.horizontal
        },
        bg = args.bg,
        shape = args.shape,
        widget = wibox.container.background,
    }

    local confirm_exit = confirm_dialogue {
        action = function() awesome.quit() end,
        text = "Exit?",
        shape = args.shape,
        bg = args.bg,
        highlight = args.fg,
        fg = args.fg,
        font = args.font,
        height = 25,
        width = 50,
        image_margins = 5,
        yes_image = "/usr/share/icons/Papirus/22x22/emblems/vcs-normal.svg",
        no_image = "/usr/share/icons/Papirus/22x22/emblems/vcs-conflicting.svg",
        visible = false,
    }

    local menu = popup_menu {
        -- TODO: set menu icons with theme
        entries = {
            {
                image = "/usr/share/icons/Papirus/24x24/apps/start-here-archlinux.svg",
                text = "Launcher",
                -- TODO: change rofi style for menu
                action = function() awful.spawn(os.getenv("HOME") .. "/.config/rofi/launchers/launcher.sh") end,
            },
            {
                image = "/usr/share/icons/Papirus/24x24/actions/key-enter.svg",
                recolor_image = true,
                text = "Hotkeys",
                action = function() hotkeys_popup:show_help(nil, awful.screen.focused()) end,
            },
            {
                image = "/usr/share/icons/Papirus/24x24/actions/reload.svg",
                recolor_image = true,
                text = "Restart",
                action = awesome.restart,
            },
            {
                image = "/usr/share/icons/Papirus/24x24/actions/exit.svg",
                recolor_image = true,
                text = "Exit",
                action = function()
                    (awful.placement.under_mouse + awful.placement.no_offscreen)(confirm_exit)
                    confirm_exit.visible = true
                end,
            }
        },
        bg = args.bg,
        highlight = args.fg,
        fg = args.fg,
        highlight_fg = args.bg,
        shape = args.shape,
        height = 25,
        font = args.font,
    }

    local pos = awful.placement[beautiful.bar_position .. '_left'] + awful.placement.no_offscreen
    local item_height = menu:geometry().height
    pos(menu, {
            margins = 5,
            offset = {
                y = beautiful.bar_position == "top" and 0 or -3 * item_height
            }
        })

    tag_icon_launcher:connect_signal("button::press", function()
        menu.visible = not menu.visible
    end)

    tag.connect_signal("property::tag_changed", function()
        -- When the current tag is changed, this function is triggered
        local tag = args.screen.selected_tag
        if tag then
            tag_icon_launcher.image = tag.icon or args.default_tag_icon
        end
    end)

    local switch_timer = gears.timer {
        timeout = 0.3,
        single_shot = true,
    }

    -- Start or stop timer
    focused_task:connect_signal("mouse::enter", function() if not switch_timer.started then switch_timer:start() end end)
    focused_task:connect_signal("mouse::leave", function() if switch_timer.started then switch_timer:stop() end end)
    tasklist:connect_signal("mouse::leave", function() if not switch_timer.started then switch_timer:start() end end)
    tasklist:connect_signal("mouse::enter", function() if switch_timer.started then switch_timer:stop() end end)
    tag_icon_launcher:connect_signal("mouse::enter", function()
        if not client.focus then
            if not switch_timer.started then switch_timer:start() end
        end
    end)

    -- Do actions when timeout
    switch_timer:connect_signal("timeout", function()
        tasklist.visible = not tasklist.visible
        focused_task.visible = not tasklist.visible
        client.emit_signal("check_focused")
    end)

    client.connect_signal("check_focused", function()
        tag_task_separator.visible = client.focus ~= nil
        widget.spacing = client.focus ~= nil and 2 or 0
    end)

    -- Emit this signal to set tag icons
    tag.emit_signal("property::tag_changed")

    return widget
end

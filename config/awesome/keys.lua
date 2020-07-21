local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helper = require("helper")
local menubar = require("menubar")
local naughty = require("naughty")
local widgets = require("widgets")

local keys = {
    alt = "Mod1",
    control = "Control",
    mod = "Mod4",
    shift = "Shift",
    tab = "Tab",
}

-- The signal is used to check for gaps when switching between tags
local tag_signal = helper.delayed_gaps_signal

-- Create a table to control clients through a menu
local controls = {
    client = nil, -- Will be set before menu is toggled
    minimize = function(self) self.client.minimized = not self.client.minimized end,
    maximize = function(self) self.client.maximized = not self.client.maximized end,
    close = function(self) self.client:kill() end,
}
local tasklist_menu = awful.menu {
    { "Minimize", function() controls:minimize() end },
    { "Maximize", function() controls:maximize() end },
    { "Close", function() controls:close() end },
}
keys.tasklist_buttons = gears.table.join(
    awful.button({ }, 1,
        function(c)
            tasklist_menu:hide()
            if c == client.focus then
                c.minimized = true
            else
                if awful.screen.focused().selected_tag ~= c.first_tag then
                    c.first_tag:view_only()
                    tag_signal:start()
                end
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end
    ),
    awful.button({ }, 3,
        function(c)
            controls.client = c
            -- Change labels depending on the client state
            tasklist_menu.items[1].label.text = c.minimized and "Unminimize" or "Minimize"
            tasklist_menu.items[2].label.text = c.maximized and "Unmaximize" or "Maximize"
            tasklist_menu:toggle()
        end
    )
)
-- Check if titlebars are enabled and toggle them
local toggle_titlebar = function(c)
    if c.has_titlebars then
        if c.titlebars_enabled then
            c.titlebars_enabled = false
            awful.titlebar.hide(c)
        else
            c.titlebars_enabled = true
            awful.titlebar.show(c)
        end
    end
end

-- Global keys
awful.keyboard.append_global_keybindings({
    -- Layout keys
    awful.key({keys.mod}, "space", function() awful.layout.inc( 1) end,
            {description = "Select next layout", group = "Layout"}),
    awful.key({keys.mod, keys.shift}, "space", function() awful.layout.inc(-1) end,
            {description = "Select previous layout", group = "Layout"}),
    awful.key({keys.mod}, "equal", function() awful.tag.incgap(5, nil); tag.emit_signal("property::gaps") end,
            {description = "Increment gaps size for the current tag", group = "Layout"}),
    awful.key({keys.mod}, "minus", function() awful.tag.incgap(-5, nil); tag.emit_signal("property::gaps") end,
            {description = "Decrement gap size for the current tag", group = "Layout"}),
    awful.key({keys.mod}, "l", function() awful.tag.incmwfact( 0.05) end,
            {description = "Increase master width factor", group = "Layout"}),
    awful.key({keys.mod}, "h", function() awful.tag.incmwfact(-0.05) end,
            {description = "Decrease master width factor", group = "Layout"}),
    awful.key({keys.mod, keys.control}, "k", function() awful.client.incwfact(0.05) end,
            {description = "Increase master width factor", group = "Layout"}),
    awful.key({keys.mod, keys.control}, "j", function() awful.client.incwfact(-0.05) end,
            {description = "Decrease master width factor", group = "Layout"}),
    awful.key({keys.mod, keys.shift}, "h", function() awful.tag.incnmaster( 1, nil, true) end,
            {description = "Increase the number of master clients", group = "Layout"}),
    awful.key({keys.mod, keys.shift}, "l", function() awful.tag.incnmaster(-1, nil, true) end,
            {description = "Decrease the number of master clients", group = "Layout"}),
    awful.key({keys.mod, keys.control}, "h", function() awful.tag.incncol(1, nil, true) end,
            {description = "Increase the number of columns", group = "Layout"}),
    awful.key({keys.mod, keys.control}, "l", function() awful.tag.incncol(-1, nil, true) end,
            {description = "Decrease the number of columns", group = "Layout"}),
    -- Tag keys
    awful.key({keys.mod}, keys.tab, function() awful.tag.history.restore(); tag.emit_signal("property::tag_changed") end,
            {description = "Toggle tags", group = "Tag"}),
    -- Launcher keys
    awful.key({keys.mod}, "Return", function() awful.spawn(variables.term) end,
            {description = "Open terminal", group = "Launcher"}),
    awful.key({keys.mod}, "d", function() awful.spawn(os.getenv("HOME") .. "/.config/rofi/launchers/launcher.sh") end,
            {description = "show rofi", group = "Launcher"}),
    -- System keys
    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("light -A 10"); widgets.update("brightness") end,
            {description = "Brigthness up", group = "System"}),
    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("light -U 10"); widgets.update("brightness") end,
            {description = "Brigthness up", group = "System"}),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
            widgets.update("volume") end,
            {description = "Toggle mute", group = "System"}),
    awful.key({}, "XF86AudioMicMute", function() awful.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle") end,
            {description = "Toggle mic mute", group = "System"}),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pamixer -i 5"); widgets.update("volume") end,
            {description = "Volume up", group = "System"}),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pamixer -d 5"); widgets.update("volume") end,
            {description = "Volume down", group = "System"}),
    awful.key({keys.mod, keys.shift}, "x", function() awful.spawn("i3lock -i " .. beautiful.lockscreen) end,
            {description = "Lockscreen", group = "System"}),
    -- Desktop keys
    awful.key({keys.mod, keys.shift}, "c", function (c) awful.spawn('copyq toggle') end,
              {description = "Toggle clipboard", group = "Desktop"}),
    awful.key({ keys.mod }, "n", function () widgets.emit_signal("notifications::toggle_center") end,
              {description = "Toggle notifcation center", group = "Desktop"}),
    awful.key({keys.mod, keys.shift}, "n", function ()
                naughty.destroy_all_notifications()
                widgets.emit_signal("notifications::clear") end,
              {description = "Dismiss notifcations", group = "Desktop"}),
    awful.key({keys.mod, keys.shift}, "e", function () awful.spawn('rofimoji') end,
              {description = "Emoji picker", group = "Desktop"})
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({keys.mod, "Control"}, "space", function(c) c.floating = not c.floating
                    if c.terminal then c.manual_float = c.floating end
                    if c.last_geometry then c:geometry(c.last_geometry) end
                end,
                {description = "Toggle floating", group = "Client"}),
        awful.key({keys.mod}, "o", function(c) c.ontop = not c.ontop end,
                {description = "Toggle window ontop", group = "client"}),
        awful.key({keys.mod, keys.shift}, "q", function(c) c:kill() end,
                {description = "Kill focused window", group = "client"}),
        awful.key({keys.mod}, "s", function(c) c.sticky = not c.sticky, c:raise() end,
                {description = "Toggle client pin", group = "client"}),
        awful.key({keys.mod}, "m", function(c) c.minimized = true end,
                {description = "Minimize focused client", group = "client"}),
        awful.key({keys.mod, keys.shift}, "f", function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                    c:emit_signal("property::size")
                end,
                {description = "Toggle fullscreen", group = "Client"}),
        awful.key({keys.alt}, keys.tab, function()
            awful.client.focus.history.previous() if client.focus then client.focus:raise() end
        end, {description = "Switch focus", group = "Client"}),
        awful.key({keys.mod}, "f", function(c)
                    c.maximized = not c.maximized
                    c:raise()
                    tag.emit_signal("property::gaps")
                end,
                {description = "Toggle maximize", group = "Client"}),
        awful.key({keys.mod}, "t", function(c)
                if c.has_titlebars then
                    if c.titlebars_enabled then
                        c.titlebars_enabled = false
                        if beautiful.titlebars_as_borders then
                            awful.titlebar(c, { position = "top", size = beautiful.titlebar_border_width })
                        else
                            awful.titlebar.hide(c)
                            if beautiful.toggle_border then
                                c.border_width = beautiful.border_width
                            end
                        end
                    else
                        c.titlebars_enabled = true
                        if beautiful.titlebars_as_borders then
                            awful.titlebar(c, beautiful.titlebar_config):setup(widgets.gen_titlebar_widgets(c))
                        else
                            awful.titlebar.show(c)
                            if beautiful.toggle_border then
                                c.border_width = 0
                            end
                        end
                    end
                end
                end,
                {description = "Toggle titlebars for a client", group = "Client"}),
        awful.key({keys.shift}, "Print", function(c)
                local screenshot_path = os.getenv("HOME") .. '/Pictures/Screenshots/' .. os.date('Screenshot_%Y%m%d_%H%M%S.png')
                awful.spawn("scrot -u " .. screenshot_path)
                gears.timer {
                    timeout = 0.2,
                    single_shot = true,
                    callback = function()
                        naughty.notify({title = "Screenshot Taken", icon = screenshot_path, icon_size = 160})
                    end,
                    autostart = true
                }
                end,
                {description = "Take a screenshot of the focused client", group = "client"}),
        awful.key({keys.mod, keys.shift}, "t",
            function()
                for _,c in ipairs(client.get()) do
                    if c.has_titlebars then
                        if beautiful.titlebars_enabled then
                            c.titlebars_enabled = false
                            if beautiful.titlebars_as_borders then
                                awful.titlebar(c, { position = "top", size = beautiful.titlebar_border_width })
                            else
                                awful.titlebar.hide(c)
                                if beautiful.toggle_border then
                                    c.border_width = beautiful.border_width
                                end
                            end
                        else
                            c.titlebars_enabled = true
                            if beautiful.titlebars_as_borders then
                                awful.titlebar(c, beautiful.titlebar_config):setup(widgets.gen_titlebar_widgets(c))
                            else
                                awful.titlebar.show(c)
                                if beautiful.toggle_border then
                                    c.border_width = 0
                                end
                            end
                        end
                    end
                end
                beautiful.titlebars_enabled = not beautiful.titlebars_enabled
                client.emit_signal("titlebar::toggle")
            end,
            {description = "Toggle titlebars for all clients", group = "Client"}),
        awful.key({keys.mod}, "j", function() awful.client.focus.byidx(1) end,
                {description = "Focus next index client", group = "Client"}),
        awful.key({keys.mod}, "k", function() awful.client.focus.byidx(-1) end,
                {description = "Focus previous index client", group = "Client"}),
        awful.key({keys.mod, keys.shift}, "j", function() awful.client.swap.byidx(1) end,
                {description = "Swap next index client", group = "Client"}),
        awful.key({keys.mod, keys.shift}, "k", function() awful.client.swap.byidx(-1) end,
                {description = "Swap previous index client", group = "Client"}),
        awful.key({keys.mod}, "u", awful.client.urgent.jumpto,
                {description = "Jump to urgent client", group = "Client"}),
        })
end)

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1,
            function(c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
            end),
        awful.button({keys.mod}, 1,
            function(c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.move(c)
            end),
        awful.button({keys.mod, keys.shift}, 1,
            function(c)
                c:emit_signal("request::activate", "mouse_click", {raise = true})
                awful.mouse.client.resize(c)
            end),
    })
end)

-- Tag keybindings
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { keys.mod },
        keygroup    = "numrow",
        description = "View tag",
        group       = "Tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
                tag_signal:again()
                tag:emit_signal("property::tag_changed")
            end
        end,
    },
    awful.key {
        modifiers = { keys.mod, keys.shift },
        keygroup    = "numrow",
        description = "Move focused client to tag",
        group       = "Tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers = { keys.mod, keys.control },
        keygroup    = "numrow",
        description = "Toggle focused client on a tag",
        group       = "Tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                    tag:emit_signal("property::tag_changed")
                end
            end
        end,
    },
})

root.keys(keys.global_keys)
root.buttons(gears.table.join(
        awful.button({}, 3, function() variables.mainmenu:toggle() end),
        awful.button({}, 1, function() variables.mainmenu:hide() end)
    ))

-- Press and hold to take a screenshot. Prevents accidental screenshots.
local screenshot_timer = gears.timer {
    timeout = 0.5,
    single_shot = true,
    callback = function()
        local screenshot_path = os.getenv("HOME") .. '/Pictures/Screenshots/' .. os.date('Screenshot_%Y%m%d_%H%M%S.png')
        awful.spawn("scrot " .. screenshot_path)
        gears.timer {
            timeout = 0.2,
            single_shot = true,
            callback = function()
                naughty.notify {
                    title = "Screenshot Taken",
                    icon = screenshot_path,
                    icon_size = 160,
                    app_name = 'scrot',
                }
            end,
            autostart = true
        }
    end
}
awful.keygrabber {
    root_keybindings = {
        {{}, "Print", function() screenshot_timer:start() end}
    },
    stop_key = "Print",
    stop_event = "release",
    stop_callback = function() if screenshot_timer.started then screenshot_timer:stop() end end,
}

return keys

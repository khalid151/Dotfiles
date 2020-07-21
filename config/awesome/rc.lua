-- Load libraries here
local beautiful = require("beautiful")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/new/theme.lua")

local awful = require("awful")
local gears = require("gears")
local helper = require("helper")
local menubar = require("menubar")
local naughty = require("notifications")
local ruled = require("ruled")
local wibox = require("wibox")
local widgets = require("widgets")
local hotkeys_popup = widgets.hotkeys_popup
local exit_confirm = widgets.confirm_dialogue {
    action = function() awesome.quit() end,
    text = "Exit?",
    width = 50,
    visible = false,
}

require("awful.autofocus")

-- VARIABLES ------------------------------------------------------------------
local running_terminals = {} -- To keep track of terminal PIDs
variables = {}
variables.term = "termite"
variables.editor = os.getenv("EDITOR") or "vi"
variables.editor_cmd = variables.term .. " -e " .. variables.editor

variables.mainmenu = awful.menu({
    { "Terminal", variables.term },
    { "Hotkeys", function() hotkeys_popup:show_help(nil, awful.screen.focused()) end },
    { "Restart", awesome.restart },
    { "Quit", function() exit_confirm.visible = true end },
})

menubar.utils.terminal = variables.term
local keys = require("keys")

-- SET DESKTOP ----------------------------------------------------------------
local function set_wallpaper(s)
    --if beautiful.wallpaper then
        --awful.spawn("feh --bg-fill " .. beautiful.wallpaper)
    --end
    gears.wallpaper.set(beautiful.wallpaper_color)
end
screen.connect_signal("property::geometry", set_wallpaper)

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.tile.right,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.top,
        awful.layout.suit.max,
    })

end)

screen.connect_signal("request::desktop_decoration", function(s)
    set_wallpaper(s)
    local l = awful.layout.suit
    helper.add_tags(s, {
        {
            name = "home",
            properties = {
                icon = beautiful.tag_icon.home,
                layout = l.floating,
                selected = true,
            }
        },
        {
            name = "internet",
            properties = {
                icon = beautiful.tag_icon.internet,
                layout = l.max
            }
        },
        {
            name = "code",
            properties = {
                icon = beautiful.tag_icon.code,
                layout = l.tile
            }
        },
        {
            name = "office",
            properties = {
                icon = beautiful.tag_icon.office,
            }
        },
        {
            name = "media",
            properties = {
                icon = beautiful.tag_icon.media,
                layout = l.max
            }
        },
        {
            name = "art",
            properties = {
                icon = beautiful.tag_icon.art,
                layout = l.tile
            }
        },
        {
            name = "games",
            properties = {
                icon = beautiful.tag_icon.games,
                layout = l.max,
            }
        },
        {
            name = "misc",
        },
        {
            name = "chat",
            properties = {
                icon = beautiful.tag_icon.chat,
                layout = l.tile
            }
        },
    })
end)

require("titlebar")
require("bar.new")

-- RULES ----------------------------------------------------------------------
ruled.client.connect_signal("request::rules", function()
    -- For all clients
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            border_color = beautiful.border_normal,
            border_width = beautiful.border_width,
            focus = awful.client.focus.filter,
            honor_padding = true,
            honor_workarea = true,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered,
            raise = true,
            screen = awful.screen.preferred,
            size_hints_honor = false,
            swallow = true,
            titlebars_enabled = true,
        }
    }
    ruled.client.append_rule {
        rule = {},
        except = { class = "Termite" },
        properties = {
            callback = function(c)
                -- Set icons
                local instance = c.instance or ''
                local icon = beautiful.icons['24x24'][instance:lower()]
                if icon then
                    c.icon = helper.icon_surface(icon)
                end

                -- Set PPID of PPID for each client // Terminal(PPID2) > Shell(PPID1) > Client
                -- TODO: find a way to tell if the window was run from multiple shells. Recursion?
                if beautiful.swallow_enabled then
                    if c.pid then
                        awful.spawn.easy_async("ps -oppid= -p" .. c.pid, function(o1)
                            awful.spawn.easy_async("ps -oppid= -p" .. o1, function(o2)
                                c.ppid = tonumber(o2)
                            end)
                        end)
                    end
                end
            end
        }
    }
    ruled.client.append_rule {
        rule = {class = "Xephyr"},
        properties = {
            icon = function() return helper.icon_surface(beautiful.icons['24x24']['computer-laptop']) end
        }
    }
    ruled.client.append_rule {
        rule = {class = "copyq", type = "normal"},
        properties = {
            floating = true,
            skip_taskbar = true,
            sticky = true,
            titlebars_enabled = false,
            width = 400,
            height = 200,
            placement = awful.placement.centered + awful.placement.top,
        }
    }
    -- To help determine terminals for window swallow thing
    ruled.client.append_rule {
        id = "terminal",
        rule = {class = "Termite"},
        properties = {
            callback = function(c)
                c.terminal = true
                if beautiful.swallow_enabled then running_terminals[tostring(c.pid)] = c end
                c.floating_on_tag = true
                local tag = awful.screen.focused().selected_tag
                if tag then
                    local check = tag.name == "internet"
                    c.floating = check
                    c.ontop = check
                    if check then awful.placement.centered(c) end
                end
            end
        }
    }
    -- For titlebars
    ruled.client.append_rule {
        rule_any = {type = "dialog" },
        properties = {
            titlebars_enabled = true,
        }
    }
    ruled.client.append_rule {
        rule = {class = "firefox"},
        properties = {
            tag = "internet",
            screen = 1,
            titlebars_enabled = false,
        }
    }
    ruled.client.append_rule {
        id = "chat",
        rule_any = {
            type = "normal",
            class = {
                "discord",
                "TelegramDesktop",
                "Thunderbird",
                "Zulip",
            }
        },
        properties = { screen = 1, tag = "chat" }
    }
    ruled.client.append_rule {
        id = "drawing",
        rule_any = {
            type = "normal",
            class = {
                "Aseprite",
                "Blender",
                "Gimp",
                "Inkscape",
                "krita",
            },
        },
        properties = { tag = "art" }
    }
    ruled.client.append_rule {
        rule = {class = "Xfdesktop", type = "desktop"},
        properties = {
            sticky = true,
            focusable = false,
            border_width = 0,
            fullscreen = true,
            titlebars_enabled = false
        }
    }
    ruled.client.append_rule {
        rule = { class = "Steam" },
        properties = {
            tag = "games",
            titlebars_enabled = false,
        },
    }
    ruled.client.append_rule {
        id = 'games',
        rule = { class = "steam_app" },
        properties = {
            tag = "games",
            callback = function(c)
                -- Prevent games from minimizing on tag change
                c:connect_signal("property::minimized", function(c)
                    if c.minimized then
                        c.minimized = false
                        c.below = true
                    end
                end)
            end
        }
    }
end)

-- SIGNALS --------------------------------------------------------------------
client.connect_signal("unfocus", function (c)
    if not helper.delayed_focus_signal.started then
        helper.delayed_focus_signal:start()
    end
    c.border_color = beautiful.border_normal
    c.border_width = beautiful.border_width
end)

client.connect_signal("focus", function (c)
    client.emit_signal("check_focused")
    c.border_color = beautiful.border_focus
    c.border_width = beautiful.border_width

    if c.class == "Termite" then
        local icon = beautiful.icons['24x24']['terminal']
        if icon then
            c.icon = helper.icon_surface(icon)
        end
    end

    local instance = c.instance or ''
    local icon = beautiful.icons['24x24'][instance:lower()]
    if icon then
        c.icon = helper.icon_surface(icon)
    end
end)

client.connect_signal("request::manage", function (c)
    if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    if beautiful.swallow_enabled and c.swallow and c.type == "normal" then
        gears.timer {
            autostart = true,
            timeout = 0.1,
            single_shot = true,
            callback = function()
                local term = running_terminals[tostring(c.ppid)]
                if term then
                    c:geometry(term:geometry())
                    term:swap(c)
                    term.hidden = true
                    term.relative_index = helper.find_client_relative_index(c)
                    c:connect_signal("swapped", function(_c)
                        term.relative_index = helper.find_client_relative_index(_c)
                    end)
                    c:connect_signal("request::unmanage", function(_c)
                        term:geometry(_c:geometry())
                        term.hidden = false
                        term:activate{}
                        awful.client.swap.byidx(term.relative_index, term)
                    end)
                end
            end
        }
    end
end)

client.connect_signal("property::geometry", function(c)
    if awful.screen.focused().selected_tag.layout.name == "floating" or c.floating then
        c.last_geometry = c:geometry()
    end
end)

tag.connect_signal("property::layout", function()
    local tag = awful.screen.focused().selected_tag
    if tag.layout.name == "floating" then
        for _,c in ipairs(tag:clients()) do c:geometry(c.last_geometry) end
    end
    helper.delayed_gaps_signal:start()
end)

tag.connect_signal("property::tag_changed", function()
    local tag = awful.screen.focused().selected_tag
    if tag.layout.name == "floating" then
        for _,c in ipairs(awful.screen.focused().clients) do
            c:geometry(c.last_geometry)
        end
    end
    -- Check if it's a terminal so you make it floating on internet tag
    for _,c in ipairs(awful.screen.focused().clients) do
        if c.terminal and c.floating_on_tag then
            if tag.name == "internet" then
                c.floating = true
            else
                -- Check if floating was changed manually
                c.floating = true and c.manual_float
            end
        end
    end
end)

-- STARTUP --------------------------------------------------------------------
awful.spawn.once("xmodmap " .. os.getenv("HOME") .. "/.xmodmap")
awful.spawn.single_instance("picom -b")
awful.spawn.single_instance("copyq")
awful.spawn.single_instance("wactions")

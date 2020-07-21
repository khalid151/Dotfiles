local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local helper = {}

helper.check_intersection = function(win1, win2)
    local x1 = win1.x
    local w1 = win1.width + x1
    local y1 = win1.y
    local h1 = win1.height + y1
    local x2 = win2.x
    local w2 = win2.width + x2
    local y2 = win2.y
    local h2 = win2.height + y2

    local x_intersec = (x2 > x1 and x2 < w1) or (w2 > x1 and w2 < w1)
    local y_intersec = (y2 > y1 and y2 < h1) or (h2 > y1 and h2 < h1)

    return x_intersec and y_intersec
end

-- The signal is used to check for gaps when switching between tags
helper.delayed_gaps_signal = gears.timer {
    timeout = 0.05,
    single_shot = true,
    callback = function()
        tag.emit_signal("property::gaps")
    end
}

helper.delayed_focus_signal = gears.timer {
    timeout = 0.01,
    single_shot = true,
    callback = function()
        client.emit_signal("check_focused")
    end
}

helper.titlebar_click_resize = function(c)
    return {
        buttons = awful.button({}, 1, function() awful.mouse.client.resize(c) end),
        layout = wibox.layout.align.horizontal
    }
end

helper.find_client_relative_index = function(c)
    local index_table = awful.client.idx(c)
    if index_table.col == 0 then
        return index_table.col + index_table.idx
    else
        return index_table.idx - index_table.num
    end
end

helper.add_tags = function(screen, args)
    for _,t in ipairs(args) do
        if not t.properties then t.properties = {} end
        t.properties['screen'] = screen
        awful.tag.add(t.name, t.properties)
    end
end

helper.cache_icons = function(pack_name, sizes)
    local sizes = sizes or "24x24;"
    local icons = {}
    for size in sizes:gmatch("([^;]+)") do
        icons[size] = {}
        awful.spawn.with_line_callback(
            string.format("find /usr/share/icons/%s/%s -name '*.svg'", pack_name, size), {
            stdout = function(line)
                local icon_name = string.match(line, '.*/(.+).svg')
                if icon_name then
                    icons[size][icon_name] = line
                end
            end,
        })
    end
    return icons
end

helper.icon_surface = function(icon_path)
    local icon = gears.surface(icon_path)
    return icon._native
end

return helper

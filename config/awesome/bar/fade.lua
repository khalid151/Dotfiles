-- Enable fading in\out for bar background
local animation = require("awesome-AnimationFramework/Animation")
local awful = require("awful")
local signal = require("widgets.signal")
local beautiful = require("beautiful")

local emit_gaps_signal = function() signal.emit_signal("check_gaps") end
emit_gaps_signal()

-- Animate and change opacity
local animation = animation {
    subject = require("wibox").widget { fade = beautiful.bar_min_opacity },
    duration = 0.2,
    target = { fade = beautiful.bar_max_opacity },
    easing = 'inOutCubic',
}

animation:connect_signal("anim::animation_updated", function(a)
    if a.screen.bar.fade ~= a.transparent then
        local opacity = math.floor(math.abs(a.subject.fade - beautiful.bar_max_opacity * a.transparent))
        opacity = opacity + (beautiful.bar_min_opacity * a.transparent)
        print(opacity, math.floor(a.subject.fade))
        a.screen.bar.bg = string.format("%s%x", beautiful.bar_bg, opacity)
    end
end)

animation:connect_signal("anim::animation_finished", function(a)
    a.subject.fade = beautiful.bar_min_opacity
    a.screen.bar.fade = a.transparent
end)

-- Functions to change opacity
local set_opaque = function(s)
    animation.screen = s
    animation.transparent = 0
    animation:startAnimation()
end

local set_transparent = function(s)
    animation.screen = s
    animation.transparent = 1
    animation:startAnimation()
end

-- Check if there are maximized windows in the currently focused screen
local check_screen_for_maxed = function(s)
    local no_max = true
    local clients = s.clients
    for _,c in ipairs(clients) do
        if c.maximized then
            set_opaque(s)
            no_max = true
            break
        else
            no_max = false
        end
    end
    if not no_max then
        set_transparent(s)
    end
end

-- Connect signals
client.connect_signal("request::manage", emit_gaps_signal)
client.connect_signal("request::unmanage", emit_gaps_signal)
tag.connect_signal("property::layout", emit_gaps_signal)
tag.connect_signal("property::tag_changed", emit_gaps_signal)
tag.connect_signal("property::useless_gap", emit_gaps_signal)

signal.connect_signal("check_gaps", function()
    local screen = awful.screen.focused()
    local current_tag = screen.selected_tag
    local layout_name = current_tag.layout.name
    current_tag.useless_gap = current_tag.useless_gap or 0
    if #screen.clients > 0 then
        if layout_name == "floating" then
            check_screen_for_maxed(screen)
        else
            if current_tag.useless_gap > 0 then
                check_screen_for_maxed(screen)
            else
                set_opaque(screen)
            end
        end
    else
        set_transparent(screen)
    end
end)

client.connect_signal("property::maximized", function(c)
    if c.maximized then
        set_opaque(c.screen)
    else
        signal.emit_signal("check_gaps")
    end
end)

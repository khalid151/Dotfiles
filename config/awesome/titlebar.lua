local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local widgets = require("widgets")
local helper = require("helper")

awful.titlebar.enable_tooltip = false

if beautiful.titlebars_as_borders then
    client.connect_signal("manage", function(c)
        if not c.titlebars_enabled then
            awful.titlebar(c, { position = "top", size = beautiful.titlebar_border_width })
        end
        awful.titlebar(c, { position = "bottom", size = beautiful.titlebar_border_width }):setup(helper.titlebar_click_resize(c))
        awful.titlebar(c, { position = "left", size = beautiful.titlebar_border_width}):setup(helper.titlebar_click_resize(c))
        awful.titlebar(c, { position = "right", size = beautiful.titlebar_border_width }):setup(helper.titlebar_click_resize(c))
    end)
end

client.connect_signal("request::titlebars",
    function(c)
        c.has_titlebars = true
        c.titlebars_enabled = true
        awful.titlebar(c, beautiful.titlebar_config):setup(widgets.titlebar.generate(c))
        if not beautiful.titlebars_enabled and c.type ~= "dialog" then
            awful.titlebar.hide(c)
            c.titlebars_enabled = false
        end
end)

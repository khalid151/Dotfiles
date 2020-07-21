local awful = require("awful")
local beautiful = require("beautiful")

local brightness = require("widgets.value_widget_template")("brightness", beautiful.brightness_icons)

brightness.update = function(self)
    awful.spawn.easy_async('light',
        function(stdout)
            self:manual_update(math.floor(tonumber(stdout)))
        end
    )
end

return brightness

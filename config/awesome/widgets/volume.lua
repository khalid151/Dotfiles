local awful = require("awful")
local beautiful = require("beautiful")

local volume = require("widgets.value_widget_template")("volume", beautiful.volume_icons)

volume.manual_update = function(self, percent, state)
    self.held_percent = percent
    self.text.text = percent .. '%'
    if not self.muted then
        local index = math.ceil((percent * #self.icons.level)/100)
        index = index == 0 and 1 or index
        self.icon.image = self.icons.level[index]
    else
        self.icon.image = self.icons.muted
    end
end

volume.update = function(self)
    awful.spawn.easy_async('pamixer --get-mute',
        function(status)
            self.muted = status == "true\n"
        end
    )
    awful.spawn.easy_async('pamixer --get-volume',
        function(percent)
            self:manual_update(tonumber(percent))
        end
    )
end

return volume

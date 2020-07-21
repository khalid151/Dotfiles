local awful = require("awful")
local beautiful = require("beautiful")

local battery = require("widgets.value_widget_template")("battery", beautiful.battery_icons)

-- Override update functions
battery.manual_update = function(self, percent, state)
    local icon_list = state ~= 0 and self.icons.charging or self.icons.discharging
    local index = math.ceil((percent * #icon_list)/100)
    self.held_percent = percent
    index = index == 0 and 1 or index
    self.icon.image = icon_list[index]
    self.text.text = percent .. '%'
end

battery.update = function(self)
    awful.spawn.easy_async_with_shell('cat /sys/class/power_supply/BAT0/{status,capacity}',
        function(stdout)
            local battery_info = {}
            for s in stdout:gmatch("(.-)\n") do table.insert(battery_info, s) end
            local status = battery_info[1]
            local percent = tonumber(battery_info[2])
            if status == 'Charging' then
                status = 1
            elseif status == 'Full' then
                status = 2
            else
                status = 0
            end
            self:manual_update(percent, status)
        end
    )
end

return battery

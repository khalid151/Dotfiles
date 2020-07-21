-- Has common functions to battery, brightness, etc
local awful = require("awful")
local wibox = require("wibox")
local signal = require("widgets.signal")

return function(name, icon_list)
    local widget = wibox.widget {
        {
            id = 'icon',
            image = icon_list[1],
            widget = wibox.widget.imagebox
        },
        {
            id = 'text',
            text = 'null',
            visible = false,
            widget = wibox.widget.textbox
        },
        held_percent = 0,
        spacing = 2,
        icons = icon_list,
        layout = wibox.layout.fixed.horizontal
    }

    widget.update = function(self)
        -- Implemented per widget
    end

    widget.manual_update = function(self, percent, state)
        local index = math.ceil((percent * #self.icons)/100)
        self.held_percent = percent
        index = index == 0 and 1 or index
        self.icon.image = self.icons[index]
        self.text.text = percent .. '%'
    end

    signal.connect_signal("widget::" .. name, function()
        widget:update()
    end)

    local tooltip = awful.tooltip {
        objects =  { widget },
        mode = 'outside',
        margins = 5,
        delay_show = 1,
        preferred_alignments  = 'middle',
        timer_function = function() return widget.held_percent .. '%' end
    }

    widget.update_text_spacing = function(self, space)
        self.spacing = space
    end

    return widget
end

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local space = wibox.widget.textbox(" ")

-- Arguments:
--      screen = the screen containing the tags
--      active = color of selected tag
--      inactive = color of unselected tag

return function(args)
    local active = args.active or "#ffffff"
    local inactive = args.inactive or "ffffffa0"
    return awful.widget.taglist {
        screen = args.screen,
        filter = awful.widget.taglist.filter.all,
        layout = {
            spacing = 10,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    id = 'index_role',
                    forced_height = 8,
                    forced_width = 8,
                    {
                        id = 'empty',
                        space,
                        bg = inactive,
                        shape = function(cr) gears.shape.arc(cr, 8, 8, 2, 0, math.pi*2) end,
                        widget = wibox.container.background
                    },
                    {
                        id = 'filled',
                        space,
                        bg = inactive,
                        shape = function(cr) gears.shape.circle(cr, 8, 8) end,
                        widget = wibox.container.background
                    },
                    widget = wibox.layout.stack
                },
                valign = 'center',
                widget = wibox.container.place
            },
            widget = wibox.container.background,
            create_callback = function(self, t, index, objects)
                local w = self:get_children_by_id('index_role')[1]
                w.filled.visible = #t:clients() > 0
                w.empty.bg = t.selected and active or inactive
                w.filled.bg = t.selected and active or inactive
            end,
            update_callback = function(self, t, index, objects)
                local w = self:get_children_by_id('index_role')[1]
                w.filled.visible = #t:clients() > 0
                w.empty.bg = t.selected and active or inactive
                w.filled.bg = t.selected and active or inactive
            end
        },
    }
end

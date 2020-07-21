local wibox = require("wibox")

return function(args)
    local layout = wibox.layout {
        last_y_position = 0, -- To keep track of the last added widget height
        layout = wibox.layout.manual,
        height = args.height or 50,
        forced_width = args.width, -- Must be set
        spacing = args.spacing or 5,
        -- TODO: fix append
        append_widgets = args.append_widgets or false,
    }

    local scroll = {
        position = 0,
        steps = args.scroll_steps or 10,
    }

    -- Handle adding new widgets
    function layout:add_widget(widget)
        -- Connect movement signal
        self:connect_signal("widget::move", function(_, delta)
            if widget then
                widget.point.y = widget._original_y + delta
                self:move_widget(widget, widget.point)
            end
        end)
        -- init point
        widget.forced_width = self.forced_width
        widget.point = {
            x = 0,
            y = self.last_y_position,
        }
        widget._original_y = widget.point.y
        widget.height = widget.forced_height or self.height
        self.last_y_position = widget.height + widget._original_y + self.spacing
        -- Add to layout
        if args.append_widgets then
            self:add(widget)
            self:emit_signal("widget::move", -1 * scroll.position)
        else
            self:insert(1, widget)
            self:emit_signal("layout::reinit")
        end
    end

    -- Handle removing a widget
    function layout:remove_widget(widget)
        local widgets = self:get_children()
        for i,w in ipairs(widgets) do
            if w == widget then
                table.remove(widgets, i)
                break
            end
        end
        self:set_children(widgets)
        self:emit_signal("widget::redraw_needed")
        self:emit_signal("layout::reinit")
        self:emit_signal("widget::removed")
    end

    -- If ID is set, return a widget by its ID
    function layout:get_widget_by_id(id)
        for _,w in ipairs(self:get_children()) do
            if w.id == id then
                return w
            end
        end
    end

    layout:connect_signal("layout::reinit", function(l)
        -- re-initiale widget positions to the last scroll point
        l.last_y_position = 0
        for _,widget in ipairs(layout:get_children()) do
            widget._original_y = l.last_y_position
            widget.height = widget.forced_height or layout.height
            l.last_y_position = widget.height + widget._original_y + l.spacing
        end
        layout:emit_signal("widget::redraw_needed")
        layout:emit_signal("widget::updated")
        l:emit_signal("widget::move", -1 * scroll.position) -- This will re-set position
        if #l:get_children() == 0 then scroll.position = 0 end
    end)
    -- Handle scroll
    layout:connect_signal("button::press", function(l, _, _, button)
        if button == 4 then
            -- scroll up
            scroll.position = scroll.position - scroll.steps
            if scroll.position <= 0 then scroll.position = 0 end
        elseif button == 5 then
            -- scroll down
            -- TODO: limit scroll down
            scroll.position = scroll.position + scroll.steps
        end
        l:emit_signal("widget::move", -1 * scroll.position)
    end)

    if args.widgets then
        for i,widget in ipairs(args.widgets) do
            layout:add_widget(widget)
        end
    end

    return layout
end

local theme_name = "new"

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local theme_path = os.getenv("HOME") .. '/.config/awesome/themes/' .. theme_name
local devices_icon_path = theme_path .. "/devices/"
local layout_icon_path = theme_path .. "/layout/"
local taglist_icon_path = theme_path .. "/taglist/"
local titlebar_icon_path = theme_path .. "/titlebar/"
local misc_icons = theme_path .. "/misc/"
local helper = require("helper")

-- Colors ---------------------------------------------------------------------
-- TODO: change colors
local theme = {
    bg = "#080708",
    fg = "#fffafb",
    color0 = "#FDCA40",
    color1 = "#2F004F",
    color2 = "#5F0A87",
    color3 = "#C65861",
}

theme.fg_normal = theme.fg
theme.fg_focus = theme.bg

theme.bg_normal = theme.bg
theme.bg_focus = theme.color0
theme.bg_urgent = theme.color3
theme.bg_systray = theme.bg

theme.wallpaper_color = theme.color3

-- Settings -------------------------------------------------------------------
theme.icon_theme = 'Papirus'
theme.icons = helper.cache_icons(theme.icon_theme, '24x24;48x48')
theme.swallow_enabled = true
theme.font_name = "Iosevka "
theme.font = theme.font_name .. "8"
theme.wallpaper = theme_path .. "/bg.jpg"
theme.lockscreen = theme_path .. "/lockscreen.png"
theme.useless_gap = 0
theme.widget_icon_margin = dpi(5)

theme.set_wallpaper = function()
    gears.wallpaper.set(theme.wallpaper_color)
end

-- Shapes ---------------------------------------------------------------------
theme.rounded_rect = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 5)
end

-- Bar config -----------------------------------------------------------------
theme.bar_name = theme_name
theme.bar_bg = theme.bg
theme.bar_height = dpi(35)
theme.bar_position = "top"
theme.bar_ontop = false
theme.bar_min_opacity = 100
theme.bar_max_opacity = 255
theme.bar_toggle_opacity = true

-- Hotkeys config -------------------------------------------------------------
theme.hotkeys_bg = theme.fg .. "d0"
theme.hotkeys_fg = theme.bg .. "f0"
theme.hotkeys_shape = theme.rounded_rect
theme.hotkeys_border_width = 0

-- Titlebars and borders ------------------------------------------------------
theme.titlebars_as_borders = false
theme.titlebar_border_width  = dpi(2)
theme.titlebars_enabled = true
theme.titlebar_autohide_controls = true
theme.titlebar_size = dpi(25)
theme.titlebar_font = theme.font
theme.titlebar_title_align = "center"
theme.titlebar_position = "top"
theme.titlebar_config = {
    position = theme.titlebar_position,
    size = theme.titlebar_size,
    font = theme.titlebar_font
}

theme.titlebar_fg_normal = theme.fg .. "30"
theme.titlebar_bg = theme.bg
theme.titlebar_fg_focus = theme.color0
theme.titlebar_bg_focus = theme.bg

-- close icons
theme.titlebar_close_button_focus  = titlebar_icon_path .. 'close_press.png'
theme.titlebar_close_button_focus_hover  = titlebar_icon_path .. 'close_hover.png'
theme.titlebar_close_button_focus_press  = titlebar_icon_path .. 'close_press.png'
theme.titlebar_close_button_normal = titlebar_icon_path .. 'close_press.png'
theme.titlebar_close_button_normal_hover = titlebar_icon_path .. 'close_hover.png'
-- minimize icons
theme.titlebar_minimize_button_focus = titlebar_icon_path .. 'min.png'
theme.titlebar_minimize_button_focus_hover = titlebar_icon_path .. 'min_hover.png'
theme.titlebar_minimize_button_normal = titlebar_icon_path .. 'min.png'
theme.titlebar_minimize_button_normal_hover = titlebar_icon_path .. 'min_hover.png'
-- maximize icons
theme.titlebar_maximized_button_focus_active = titlebar_icon_path .. "unmax.png"
theme.titlebar_maximized_button_focus_active_hover = titlebar_icon_path .. "unmax_hover.png"
theme.titlebar_maximized_button_focus_inactive = titlebar_icon_path .. "max.png"
theme.titlebar_maximized_button_focus_inactive_hover = titlebar_icon_path .. "max_hover.png"
theme.titlebar_maximized_button_normal_active = titlebar_icon_path .. "unmax.png"
theme.titlebar_maximized_button_normal_active_hover = titlebar_icon_path .. "unmax_hover.png"
theme.titlebar_maximized_button_normal_inactive = titlebar_icon_path .. "max.png"
theme.titlebar_maximized_button_normal_inactive_hover = titlebar_icon_path .. "max_hover.png"
-- TODO: ontop icons
-- TODO: floating
-- sticky icons
theme.titlebar_sticky_button_normal_inactive = titlebar_icon_path .. "empty.png"
theme.titlebar_sticky_button_focus_inactive  = titlebar_icon_path .. "pin_inactive.png"
theme.titlebar_sticky_button_focus_inactive_hover  = titlebar_icon_path .. "pin_inactive_hover.png"
theme.titlebar_sticky_button_normal_active = titlebar_icon_path .. "pin.png"
theme.titlebar_sticky_button_focus_active  = titlebar_icon_path .. "pin.png"
theme.titlebar_sticky_button_focus_active_hover  = titlebar_icon_path .. "pin_hover.png"

if theme.titlebars_as_borders then
    theme.border_width  = 0
else
    theme.border_width  = dpi(1)
end

theme.border_normal = theme.bg
theme.border_focus  = theme.color0

-- Notifications --------------------------------------------------------------
theme.notification_padding = dpi(10)
theme.notification_width = dpi(300)
theme.notification_height = dpi(100)
theme.notification_max_width = dpi(300)
theme.notification_icon_size = dpi(100)
theme.notification_border_width = 0
theme.notification_spacing = dpi(5)
theme.notification_font = theme.font_name .. ' 8'
theme.notification_font_title = 'Teko 12'
theme.notification_position = "top_middle"
theme.notification_bg_normal = theme.fg .. "fe"
theme.notification_fg_normal = theme.bg
theme.notification_bg_critical = "#ff3838"
theme.notification_fg_critical = "#ffffff"
theme.notification_center_bg = theme.bg .. "80"

gears.timer {
    timeout = 2,
    single_shot = true,
    autostart = true,
    callback = function()
        theme.notification_default_icon = theme.icons['48x48']['dialog-information']
        theme.notification_error_icon = theme.icons['48x48']['computer-fail']
    end
}

-- Menus ----------------------------------------------------------------------
theme.menu_border_width = 0
theme.menu_height = dpi(20)
theme.menu_width  = dpi(100)

-- Icons ----------------------------------------------------------------------
theme.tag_icon = {
    home = "/usr/share/icons/Papirus/24x24/actions/go-home.svg",
    internet = "/usr/share/icons/Papirus/24x24/actions/globe.svg",
    code = "/usr/share/icons/Papirus/24x24/actions/dialog-xml-editor.svg",
    office = "/usr/share/icons/Papirus/24x24/actions/fileopen.svg",
    media = "/usr/share/icons/Papirus/24x24/actions/view-media-track.svg",
    art = "/usr/share/icons/Papirus/24x24/actions/draw-path.svg",
    games = "/usr/share/icons/Papirus/24x24/actions/draw-cuboid.svg",
    chat = "/usr/share/icons/Papirus/24x24/actions/dialog-messages.svg",
    default = "/usr/share/icons/Papirus/24x24/actions/cm_options.svg",
}

theme.battery_icons = {
    charging = {
        devices_icon_path .. 'batt_25_ch.png',
        devices_icon_path .. 'batt_50_ch.png',
        devices_icon_path .. 'batt_75_ch.png',
        devices_icon_path .. 'batt_fu_ch.png',
    },
    discharging = {
        devices_icon_path .. 'batt_25_di.png',
        devices_icon_path .. 'batt_50_di.png',
        devices_icon_path .. 'batt_75_di.png',
        devices_icon_path .. 'batt_fu_di.png',
    }
}
theme.volume_icons = {
    level = {
        devices_icon_path .. 'sound_0.png',
        devices_icon_path .. 'sound_1.png',
        devices_icon_path .. 'sound_2.png',
        devices_icon_path .. 'sound_3.png',
    },
    muted = devices_icon_path .. 'sound_m.png'
}
theme.brightness_icons = {
    devices_icon_path .. 'brightness_00.png',
    devices_icon_path .. 'brightness_25.png',
    devices_icon_path .. 'brightness_50.png',
    devices_icon_path .. 'brightness_75.png',
    devices_icon_path .. 'brightness_fu.png',
}

theme.arrow_icon_left = misc_icons .. 'arrow_left.png'
theme.arrow_icon_right = misc_icons .. 'arrow_right.png'
theme.distro_icon = misc_icons .. 'arch.png'

return theme

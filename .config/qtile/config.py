import os
import subprocess

from libqtile import qtile
from libqtile.config import Click, Drag, Group, KeyChord, Key, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy

ALT = 'mod1'
ALT2 = 'mod5'
MOD = 'mod4'
SHIFT = 'shift'

class Commands(object):
    menu = 'rofi -show combi'
    notify = "dunstify '{}'"
    notify_toggle = "dunstctl set-paused toggle"
    terminal = 'alacritty'
    lock = 'xscreensaver-command -lock'
    files = 'alacritty -e lf'
    notes = 'alacritty -e joplin'
    audio = 'pavucontrol'
    passwords = 'bitwarden-desktop'
    clipboard = "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"
    screenshot = "flameshot gui"
    greenclip = "systemctl --user start greenclip.service"

    audio_mute = "amixer -q set Master toggle"
    audio_up = "amixer -q set Master 5%+"
    audio_down = "amixer -q set Master 5%-"

    light_up = "sudo light -A 10"
    light_down = "sudo light -U 10"

    blugon_down = "blugon --setcurrent='-600'"
    blugon_up = "blugon --setcurrent='+600'"
    blugon_restart = "systemctl --user restart blugon.service"

    xrandr = "xrandr"
    monitor_single = "xrandr --auto --output eDP-1 --primary"
    dell_integrated = "xrandr --auto --output DP-1-2 --primary --mode 3440x1440 --above eDP-1"
    dell_hybrid = "xrandr --auto --output DP-1-1 --primary --mode 3440x1440 --above eDP-1"
    dell_nvidia = "xrandr --auto --output DP-1 --primary --mode 3440x1440 --above eDP-1-1"
    projector = "xrandr --auto --output HDMI-1-1 --mode 1920x1080 --same-as eDP-1-1"
    wallpaper_reset = "feh --bg-fill --no-fehbg ~/Pictures/Wallpapers/firewatch_6.jpg"

    om_integrated = "optimus-manager --switch integrated --no-confirm"
    om_hybrid = "optimus-manager --switch hybrid --no-confirm"
    om_nvidia = "optimus-manager --switch nvidia --no-confirm"

    autostart = [wallpaper_reset, greenclip, blugon_restart]

keys = [
    # Applications
    Key([MOD], 'c', lazy.spawn(Commands.clipboard)),
    Key([MOD], 'w', lazy.spawn(Commands.notes)),
    Key([MOD], 'e', lazy.spawn(Commands.files)),
    Key([MOD], 'a', lazy.spawn(Commands.audio)),
    Key([MOD], 'p', lazy.spawn(Commands.passwords)),
    Key([MOD], 'n', lazy.spawn(Commands.notify_toggle)),
    Key([], "Print", lazy.spawn(Commands.screenshot)),

    # Multimedia and function keys
    Key([], 'XF86AudioRaiseVolume', lazy.spawn(Commands.audio_up)),
    Key([], 'XF86AudioLowerVolume', lazy.spawn(Commands.audio_down)),
    Key([], 'XF86AudioMute', lazy.spawn(Commands.audio_mute)),
    Key([], 'XF86AudioMicMute', lazy.spawn(Commands.audio_mute)),
    Key([], 'XF86MonBrightnessUp', lazy.spawn(Commands.light_up)),
    Key([], 'XF86MonBrightnessDown', lazy.spawn(Commands.light_down)),

    ### The essentials
    Key([MOD], "Return", lazy.spawn(Commands.terminal)),
    Key([MOD], "Tab", lazy.spawn(Commands.menu)),
    Key([MOD], "space", lazy.next_layout()),
    Key([MOD], "q", lazy.window.kill()),
    Key([MOD, "shift"], "r", lazy.restart()),
    Key([MOD, "shift"], "q", lazy.shutdown()),

    # ### Switch focus to specific monitor (out of three)
    # Key([MOD], "w", lazy.to_screen(0)),
    # Key([MOD], "e", lazy.to_screen(1)),
    # Key([MOD], "r", lazy.to_screen(2)),

   # Switch focus of monitors
    Key([MOD], "s", lazy.next_screen()),
    Key([MOD], "period", lazy.next_screen()),
    Key([MOD], "comma", lazy.prev_screen()),

    ### Window controls
    Key([MOD], "j", lazy.layout.down()),
    Key([MOD], "k", lazy.layout.up()),
    # Key([MOD], "h", lazy.layout.left()),
    # Key([MOD], "l", lazy.layout.right()),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), lazy.layout.section_down()),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), lazy.layout.section_up()),
    # Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), lazy.layout.section_left()),
    # Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), lazy.layout.section_right()),

    Key([MOD], "h", lazy.layout.shrink(), lazy.layout.decrease_nmaster()),
    Key([MOD], "l", lazy.layout.grow(), lazy.layout.increase_nmaster()),
    # Key([MOD], "n", lazy.layout.normalize()),

    # Key([MOD], "m", lazy.layout.maximize()),
    Key([MOD, "shift"], "f", lazy.window.toggle_floating()),
    Key([MOD], "f", lazy.window.toggle_fullscreen()),

    # Blugon blue light change
    KeyChord([MOD], "b", [
        Key([], "d", lazy.spawn(Commands.blugon_down)),
        Key([], "u", lazy.spawn(Commands.blugon_up)),
        Key([], "r", lazy.spawn(Commands.blugon_restart)),
    ]),

    # Monitor config
    KeyChord([MOD], "m", [
        Key([], "s",
            lazy.spawn(Commands.monitor_single),
            lazy.spawn(Commands.notify.format("Single monitor configured")),
            lazy.restart()
        ),
        Key([], "i",
            lazy.spawn(Commands.xrandr),
            lazy.spawn(Commands.dell_integrated),
            lazy.spawn(Commands.notify.format("Dell monitor configured for integrated mode")),
            lazy.restart()
        ),
        Key([], "h",
            lazy.spawn(Commands.dell_hybrid),
            lazy.spawn(Commands.notify.format("Dell monitor configured for hybrid mode")),
        ),
        Key([], "n",
            lazy.spawn(Commands.dell_nvidia),
            lazy.spawn(Commands.notify.format("Dell monitor configured for nvidia mode")),
        ),
        Key([], "p",
            lazy.spawn(Commands.projector),
            lazy.spawn(Commands.notify.format("Projector configured for HDMI")),
        ),
        Key([], "w",
            lazy.spawn(Commands.wallpaper_reset),
            lazy.spawn(Commands.notify.format("Wallpaper reset")),
            lazy.restart()
        ),
    ]),

    # Optimus Manager graphics card switching
    KeyChord([MOD], "g", [
        Key([], "i", lazy.spawn(Commands.om_integrated)),
        Key([], "h", lazy.spawn(Commands.om_hybrid)),
        Key([], "n", lazy.spawn(Commands.om_nvidia)),
    ]),

    # Locking and exiting
    KeyChord([MOD], "ESC", [
        Key([], "i", lazy.spawn(Commands.om_integrated)),
        Key([], "h", lazy.spawn(Commands.om_hybrid)),
        Key([], "n", lazy.spawn(Commands.om_nvidia)),
    ])
]

# groups = [Group(str(i)) for i in [x for x in range(1, 20) if x != 10]]
groups = [Group(str(i)) for i in (1, 2, 3, 4, 5, 11, 12, 13, 14, 15)]

for group in groups:

    if len(group.name) > 1:
        keys.extend([
            Key([ALT], group.name[1], lazy.group[group.name].toscreen(toggle=False)),
            Key([ALT, "shift"], group.name[1], lazy.window.togroup(group.name, switch_group=False))
        ])

    else:
        keys.extend([
            Key([MOD], group.name, lazy.group[group.name].toscreen(toggle=False)),
            Key([MOD, "shift"], group.name, lazy.window.togroup(group.name, switch_group=False)),
        ])


# groups = [Group(i) for i in "1234567890"]

# for mod in [MOD, ALT]:
    # for i in groups:
        # keys.extend([
            # Key([mod], i.name, lazy.group[i.name].toscreen(toggle=False)),
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False)),
        # ])

layout_theme = {"border_width": 2,
                "margin": 0,
                "border_focus": "#5294e2",
                "border_normal": "#434758"
                }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(name='full', **layout_theme),
]

class Theme(object):
    bar = {
        'size': 24,
        'background': '#383c4a',
        'opacity': 1.0
    }
    widget = {
        'font': 'FiraCode Nerd Font Retina',
        'fontsize': 14,
        'background': bar['background'],
        # 'foreground': 'EEEEEE'
        'foreground': '#F9FAF9'
    }
    text = {
        'font': 'FiraCode Nerd Font Retina',
        'fontsize': 12,
        'background': bar['background'],
        # 'foreground': '#F9FAF9'
    }
    # graph = {
        # 'background': bar['background'],
        # 'border_width': 0,
        # 'line_width': 2,
        # 'margin_x': 5,
        # 'margin_y': 5,
        # 'width': 50,
        # 'frequency': 0.1
    # }
    groupbox = dict(widget)
    groupbox.update({
        # 'padding': 3,
        'borderwidth': 3,
        'margin_y': 2,
        'margin_x': 0,
        'padding_y': 3,
        'padding_x': 2,
        'active': '#F9FAF9',
        # 'active': '#5294e2',
        'inactive': '#4b5162',
        'rounded': True,
        'highlight_color': '#2e9ef4',
        # 'highlight_method': "line",
        'this_current_screen_border': '#2e9ef4',
        # 'this_screen_border': colors[2],
        # 'other_current_screen_border': colors[2],
        # 'other_screen_border': colors[4],
    })
    sep = {
        'padding': 10,
        'linewidth': 2,
        'background': bar['background'],
        'foreground': '#4b5162',
        'height_percent': 75
    }
    systray = dict(widget)
    systray.update({
        'icon_size': 18,
        'padding': 5
    })

def init_widgets_list():
    return [
        widget.Sep(**Theme.sep),
        widget.Image(
            filename = "~/.config/qtile/icons/python-white.png",
            scale = "False",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(Commands.terminal)}
        ),
        widget.Sep(**Theme.sep),

        widget.GroupBox(**Theme.groupbox),
        widget.Sep(**Theme.sep),

        widget.CurrentLayoutIcon(
            custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            scale = 0.7,
            **Theme.widget
        ),
        widget.CurrentLayout(**Theme.widget),
        widget.Sep(**Theme.sep),

        widget.WindowName(**Theme.widget),

        widget.Cmus(**Theme.widget),
        widget.Sep(**Theme.sep),

        widget.TextBox(text = " 🔊 " , **Theme.text),
        widget.Volume(
            update_interval=1,
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('pavucontrol')},
            **Theme.widget
        ),
        widget.Sep(**Theme.sep),

        widget.TextBox(text = " 🌡 " ,**Theme.text),
        widget.ThermalSensor(threshold=80, update_interval=1, **Theme.widget),
        widget.Sep(**Theme.sep),

        # widget.Net(
            # interface="wlp0s20f3",
            # format='{down} ↓↑ {up}',
            # update_interval=1,
            # use_bits=True,
            # **Theme.widget),
        # widget.Sep(**Theme.sep),

        # widget.Backlight(**Theme.widget),
        # widget.Sep(**Theme.sep),

        widget.Battery(
            # format='{char} {percent:2.0%} {hour:d}:{min:02d} {watt:.2f} W',
            format='{char} {percent:1.0%}  {hour:d}:{min:02d}',
            full_char="  ",
            unknown_char="  ",
            charge_char=" ",
            discharge_char="⚡",
            update_interval=1,
            show_short_text=False,
            **Theme.widget),
        widget.Sep(**Theme.sep),

        widget.Clock(
            # format='W%W D%j ~ %a  %d-%m-%y ~ %H:%M:%S',
            format='%a  %d-%m-%Y ~ %H:%M:%S',
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(Commands.terminal + ' -e calcurse')},
            **Theme.widget
        ),
        widget.Sep(**Theme.sep),

        widget.Systray(**Theme.systray),
        widget.Sep(**Theme.sep),

        widget.CheckUpdates(
            update_interval = 1800,
            distro = "Arch_checkupdates",
            display_format = "⟳ {updates}",
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(Commands.terminal + ' -e yay -Syu')},
        ),
        widget.Sep(**Theme.sep),
    ]

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_list(), **Theme.bar)),
            Screen(top=bar.Bar(widgets=init_widgets_list(), **Theme.bar))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()

mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([MOD], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.floating.Floating(
    float_rules=[{'wmclass': wmclass} for wmclass in (
        'Download',
        'Conky',
        'Pavucontrol',
        'GParted',
        'alsamixer',
        'galculator'
    )],
    auto_float_types=[
        'notification',
        'toolbar',
        'splash',
        'dialog'
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.startup
def autostart():
    for command in Commands.autostart:
        subprocess.Popen([command], shell=True)

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

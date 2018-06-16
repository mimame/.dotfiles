from i3pystatus import Status

status = Status(standalone=True)

# Default color: $base05 #f8f8f2
base05 = "#f8f8f2"

# Screen backlight info
# requires light to change the backlight brightness with the scollwheel.
status.register("backlight",
                backlight="radeon_bl0",
                format=" {percentage}% ",
                on_upscroll="light -A 1",
                on_downscroll="light -U 1",
                interval=1,)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
                step=1,
                format=" {volume}% ",)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
                format=" %a %-d %b %X KW%V",)

status.register("uptime",
                format=" {hours}:{mins}",
                interval=1,)

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
#status.register("battery",
#    format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%] {remaining:%E%hh:%Mm}",
#    alert=True,
#    alert_percentage=5,
#    status={
#        "DIS": "↓",
#        "CHR": "↑",
#        "FULL": "=",
#    },)

# This would look like this:
# Discharging 6h:51m
status.register("battery",
                format="{status} {remaining:%E%hh:%Mm}",
                alert=True,
                alert_percentage=30,
                critical_level_percentage=30,
                interval=1,
                # $base05
                full_color=base05,
                charging_color=base05,
                status={
                    "DIS":  "",
                    "CHR":  "",
                    "FULL": "",
                },)


# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load",
                format=" {tasks} {avg1} {avg5} {avg15}",)


#status.register("cpu_usage_graph",
#    start_color=base05,)

status.register("cpu_freq",
                format=" {avgg}",
                interval=1,)

status.register("cpu_usage_bar",
                bar_type="vertical",
                format=" {usage_bar}",
                # $base05
                start_color=base05,
                interval=1,)

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
                format=" {Package_id_0}°C",
                lm_sensors_enabled=True,
                interval=1,)

# Displays whether a DHCP client is running
#status.register("runwatch",
#    name="DHCP",
#    path="/var/run/dhclient*.pid",)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
                interface="enp9s0",
                # $base05
                color_up=base05,
                start_color=base05,
                format_up="{v4cidr}  {bytes_recv}KiB  {bytes_sent}KiB",
                format_down="",
                interval=1,)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
                interface="wlp8s0",
                # $base05
                color_up=base05,
                start_color=base05,
                format_up=" {essid} {quality}%  {bytes_recv}KiB  {bytes_sent}KiB",
                format_down="",
                interval=1,)

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
                path="/",
                format=" {avail}G",
                on_leftclick="baobab",
                interval=1,)

# pomodoro timer
status.register("pomodoro",
                sound="/usr/share/sounds/freedesktop/stereo/bell.oga",
                interval=1,)

#status.register("updates",
#                format = "Updates: {count}",
#                format_no_updates = "No updates",
#                backends = [pacman.Pacman(), cower.Cower()])

#status.register("weather",
#    colorize=True,
#    location_code="SPXX0050",
#    format = "{current_temp} {humidity}%")

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
#status.register("mpd",
#    format="{title}{status}{album}",
#    status={
#        "pause": "▷",
#        "play": "▶",
#        "stop": "◾",
#    },)

status.run()

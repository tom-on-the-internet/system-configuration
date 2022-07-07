{ config, lib, pkgs, ... }:

{
  home.file = {
    ".config/sway/config".text = ''
      ### Variables
      set $mod Mod4
      set $left h
      set $down j
      set $up k
      set $right l
      set $term footclient
      set $menu rofi -show drun

      exec swayidle -w \
        timeout 300  'swaylock' \
        timeout 480  'swaymsg "output * dpms off"' \
        resume  'swaymsg "output * dpms on"' \
        timeout 1020 'systemctl suspend' \
        before-sleep 'swaylock'

      # This will lock your screen after 300 seconds of inactivity, then turn off
      # your displays after another 300 seconds, and turn your screens back on when
      # resumed. It will also lock your screen before your computer goes to sleep.

      input "type:keyboard" {
          # how long before repeat (MS)
          repeat_delay 200
          # how many times to repeat in 1 second
          repeat_rate 50
      }

      input "type:pointer" {
          pointer_accel '1'
          scroll_factor 5
      }

      input "type:touchpad" {
          events disabled
      }

      ### Key bindings
      #
      # Basics:
      #
      # Start a terminal
      bindsym $mod+Return exec $term

      # Kill focused window
      bindsym $mod+w kill

      # Sticky
      bindsym $mod+comma sticky toggle

      # Start your launcher
      bindsym $mod+space exec $menu

      # Drag floating windows by holding down $mod and left mouse button.
      # Resize them with right mouse button + $mod.
      # Despite the name, also works for non-floating windows.
      # Change normal to inverse to use left mouse button for resizing and right
      # mouse button for dragging.
      floating_modifier $mod normal

      # Reload the configuration file
      bindsym $mod+r reload

      # Exit sway (logs you out of your Wayland session)
      bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
      #
      # Moving around:
      #
      # Move your focus around
      bindsym $mod+$left focus left
      bindsym $mod+$down focus down
      bindsym $mod+$up focus up
      bindsym $mod+$right focus right

      # Move the focused window with the same, but add Shift
      bindsym $mod+Shift+$left move left
      bindsym $mod+Shift+$down move down
      bindsym $mod+Shift+$up move up
      bindsym $mod+Shift+$right move right

      #
      # Workspaces:
      #
      # Switch to workspace
      bindsym $mod+1 workspace number 1
      bindsym $mod+2 workspace number 2
      bindsym $mod+3 workspace number 3
      bindsym $mod+4 workspace number 4
      bindsym $mod+5 workspace number 5
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9
      bindsym $mod+0 workspace number 10

      # Move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number 1
      bindsym $mod+Shift+2 move container to workspace number 2
      bindsym $mod+Shift+3 move container to workspace number 3
      bindsym $mod+Shift+4 move container to workspace number 4
      bindsym $mod+Shift+5 move container to workspace number 5
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9
      bindsym $mod+Shift+0 move container to workspace number 10

      #
      # Layout stuff:
      #
      # You can "split" the current object of your focus with
      # $mod+b or $mod+v, for horizontal and vertical splits
      # respectively.
      bindsym $mod+b splith
      bindsym $mod+v splitv

      # Make the current focus fullscreen
      bindsym $mod+f fullscreen

      # Toggle the current focus between tiling and floating mode
      bindsym $mod+Shift+space floating toggle

      #
      # Status Bar:
      #
      # Read `man 5 sway-bar` for more information about this section.
      bar {
        swaybar_command waybar
        position top
        mode hide
        modifier mod4
      }

      default_border pixel 1
      client.focused "#2c2c2c" "#dddfe2" "#000000" "#d06e76" "#88b18f"

      gaps inner 10

      include @sysconfdir@/sway/config.d/*
      exec dbus-sway-environment
      exec configure-gtk
      exec swaybg -m fill -i $HOME/.config/wall
      exec foot -Ss
      exec google-chrome-stable --no-startup-window
      exec dropbox start
      exec blueman-applet
      exec copyq
      exec_always autotiling

      # Don't show borders unless there's more than one visible window.
      smart_borders on

      seat * hide_cursor 10000
      focus_follows_mouse no

      # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      bindsym $mod+Semicolon exec copyq show

      # Volume
      bindsym {
        XF86AudioRaiseVolume  exec pamixer -i 5
        XF86AudioLowerVolume  exec pamixer -d 5
        XF86AudioMute         exec pamixer -t
      }

      assign [app_id="google-chrome"] 2
      assign [title="Slack.*"] workspace 4
    '';
  };
  home.file = {
    ".config/swaylock/config".text = ''
      daemonize
      color=#000000
    '';
  };
}

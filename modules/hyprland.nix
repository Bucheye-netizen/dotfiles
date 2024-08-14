{ inputs, ... }:
let colors = import ../util/colors.nix;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
      };
      decoration = {
        rounding = 5;
        active_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };
      general = {
        gaps_out = 10;
        sensitivity = 0.7;
        "col.active_border" = "rgb(${colors.toHypr colors.gruv.dark3})";
        "col.inactive_border" = "rgb(${colors.toHypr colors.gruv.dark1})";
        border_size = 2;
      };
      input.touchpad.scroll_factor = 0.2;
    };

    settings = {
      bind = [
        "SUPER,Q,exec,kitty"
        "SUPER, R, exec, fuzzel"
        "SUPER, X, exec, firefox"
        "SUPER, Tab, cyclenext"
        "SUPER, Tab, bringactivetotop"
        "SUPER_SHIFT, Tab, cyclenext, prev"
        "SUPER_SHIFT, Tab, bringactivetotop"
        "SUPER, S, exec, hyprshot -m region --clipboard-only"
        "SUPER, T, togglefloating"
        "SUPER, W, killactive"
        "SUPER, F, fullscreen"
        "SUPER, K, fakefullscreen"
        "SUPER, M, fullscreen, 1"
        "SUPER, C, centerwindow"
        "SUPER, L, exec, hyprlock"
        "SUPER, P, exec, hyprpicker -a"
        ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
      bindl = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 100+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 100-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
      exec-once = [ "hyprctl setcursor 'Capitaine Cursors (Gruvbox)' 18" ];
      bindm =
        [ "SUPER, mouse:273, resizewindow" "SUPER, mouse:272, movewindow" ];
      windowrulev2 = [
        "float,class:^(org.gnome.Nautilus)"
        "float,class:^(.blueman-manager-wrapped)"
        "float,class:^(swayimg)"
        "size 70% 70%, class:^(swayimg)"
      ];
      env = [ "XCURSOR_THEME,'Capitaine Cursors (Gruvbox)'" "XCURSOR_SIZE,18" ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [ "${inputs.self}/wallpaper/gruvbox.png" ];
      wallpaper = [ "eDP-1,${inputs.self}/wallpaper/gruvbox.png" ];
    };
  };

  programs.hyprlock = {
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = false;
        no_fade_in = false;
      };

      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
    };
    enable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 290;
          on-timeout = ''notify-send "Idl" "PC will lock in 10 seconds"'';
        }
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.wlogout = { enable = true; };
}

{ self, ... }:
let
  colors = import ../util/colors.nix;
  active = "rgb(${colors.toHypr colors.gruv.light2})";
  inactive = "rgb(${colors.toHypr colors.gruv.dark3})";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # review https://www.reddit.com/r/hyprland/comments/164qtv5/keybind_to_change_refresh_rate/
      # monitor = "eDP-2, 2560x1600@165.00200, 0x0, 1";
      # monitor = "eDP-2, 2560x1600@60.00200, 0x0, 1";
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
        # "col.active_border" = "rgb(${colors.toHypr colors.gruv.dark3})";
        "col.active_border" = "rgb(${colors.toHypr colors.gruv.light4})";
        "col.inactive_border" = "rgb(${colors.toHypr colors.gruv.dark1})";
        border_size = 2;
      };
      input = {
        sensitivity = 0.3;
        touchpad.scroll_factor = 0.2;
      };
    };

    # Inspired by https://github.com/AymanLyesri/hyprland-conf/blob/master/.config/hypr/configs/keybinds.conf
    settings = {
      bind = [
        # Apps
        "SUPER, Q,exec,kitty"
        "SUPER, R, exec, fuzzel"
        "SUPER, X, exec, firefox"
        "SUPER, PERIOD, exec, bemoji --type"

        "SUPER, Tab, cyclenext"
        "SUPER, Tab, bringactivetotop"

        # Actions 
        "SUPER_SHIFT, S, exec, hyprshot -m region --clipboard-only"
        "CTRL_ALT, DELETE, exec, systemctl suspend"

        "SUPER, T, togglefloating"
        "SUPER, W, killactive"
        "SUPER, F, fullscreen"
        "SUPER, M, fullscreen, 1"
        "SUPER_SHIFT, M, fullscreenstate, -1, 2" # Partial fullscreen

        # Navigation
        "SUPER_SHIFT, Tab, cyclenext, prev"
        "SUPER_SHIFT, Tab, bringactivetotop"

        "SUPER, C, centerwindow"
        "SUPER, P, exec, hyprpicker -a"

        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"

        "SUPER_SHIFT, H, movewindow, l"
        "SUPER_SHIFT, L, movewindow, r"
        "SUPER_SHIFT, J, movewindow, d"
        "SUPER_SHIFT, K, movewindow, u"
      ];
      binde = [
        "SUPER_CTRL, H, resizeactive,-50 0"
        "SUPER_CTRL, L, resizeactive,50 0"
        "SUPER_CTRL, J, resizeactive,0 50"
        "SUPER_CTRL, K, resizeactive,0 -50"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
      exec-once = [ "hyprctl setcursor 'Capitaine Cursors (Gruvbox)' 24" ];
      bindm =
        [ "SUPER, mouse:273, resizewindow" "SUPER, mouse:272, movewindow" ];
      windowrulev2 = [
        "float,class:^(org.gnome.Nautilus)"
        "float,class:^(.blueman-manager-wrapped)"
        "float,class:^(swayimg)"
        "size 70% 70%, class:^(swayimg)"
        "float, class:^(org.pulseaudio.pavucontrol)"
        "float, class:^(org.bucheye.debug)"
        "float, class:^(xdg-desktop-portal-gtk)"
        "opacity 0.9, class:^(kitty)"
      ];
      env = [ "XCURSOR_THEME,'Capitaine Cursors (Gruvbox)'" "XCURSOR_SIZE,24" ];
      xwayland = { force_zero_scaling = true; };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [ "${self}/wallpaper/gruvbox.png" ];
      wallpaper = [ "eDP-2,${self}/wallpaper/gruvbox.png" ];
    };
  };

  # Basically copied from https://github.com/binEpilo/hyprland-gruvbox-rice-/blob/main/hypr/hyprlock.conf
  programs.hyprlock = {
    settings = {
      general = { hide_cursor = 0; };

      background = {
        path = "${self}/wallpaper/hyprlock.png";
        blur_passes = 1;
        blur_size = 8;
        noise = 1.17e-2;
        contrast = 0.8916;
        brightness = 0.5172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      label = {
        monitor = "eDP-2";
        text = "$TIME";
        color = active;
        font_size = 100;
        rotate = 0;
        position = "0, 80";
        halign = "center";
        valign = "center";
      };

      input-field = {
        monitor = "eDP-2";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = false;
        dots_rounding = -1;
        outer_color = inactive;
        inner_color = inactive;
        font_color = active;
        fade_on_empty = true;
        fade_timeout = 1000;
        placeholder_text = "<i></i>";
        hide_input = 0;
        rounding = -1;
        check_color = active;
        fail_color = active;
        fail_transition = 300;
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1;
        invert_numlock = false;
        swap_font_color = false;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
    enable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 150;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = 300;
          on-timeout = "loginctl locke-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.wlogout = { enable = true; };
}

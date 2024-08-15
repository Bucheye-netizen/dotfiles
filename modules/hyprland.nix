{ inputs, ... }:
let
  colors = import ../util/colors.nix;
  active = "rgb(${colors.toHypr colors.gruv.light2})";
  inactive = "rgb(${colors.toHypr colors.gruv.dark3})";
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
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"
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
        "float, class:^(org.pulseaudio.pavucontrol)"
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

  # Basically copied from https://github.com/binEpilo/hyprland-gruvbox-rice-/blob/main/hypr/hyprlock.conf
  programs.hyprlock = {
    settings = {
      general = { hide_cursor = 0; };

      background = {
        path = "${inputs.self}/wallpaper/hyprlock.png";
        blur_passes = 1;
        blur_size = 8;
        noise = 1.17e-2;
        contrast = 0.8916;
        brightness = 0.5172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      label = {
        monitor = "eDP-1";
        text = "$TIME";
        color = active;
        font_size = 100;
        rotate = 0;
        position = "0, 80";
        halign = "center";
        valign = "center";
      };

      input-field = {
        monitor = "eDP-1";
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

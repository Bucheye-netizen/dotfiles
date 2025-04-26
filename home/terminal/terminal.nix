{...}: {
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "100";
  };

  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./fastfetch.json);
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.auto-format = true;
    languages.language = [
      {
        name = "rust";
        auto-format = true;
      }
      {
        name = "nix";
        formatter.command = "alejandra";
        auto-format = true;
      }
    ];
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkMedium";
    font = {
      size = 8;
      name = "JetBrainsMono Nerd Font";
    };
    settings = let
      colors = import ./../util/colors.nix;
    in {
      # scrollback_pager = "nvim -c \"set norelativenumber nonumber nolist showtabline=0 foldcolumn=0\" -c \"autocmd TermOpen * normal G\" -c \"silent! write /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - \"";
      scrollback_pager = "nvim -R --noplugin -c \"set signcolumn=no showtabline=0 nonumber foldcolumn=0 cmdheight=0 laststatus=0\" -c \"silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - \" -c \"normal G\"";
      cursor_trail = 1;
      touch_scroll_multiplier = 2.0;
      cursor_trail_start_threshold = 0;
      repaint_delay = 5;
      sync_to_monitor = "yes";
      tab_bar_style = "slant";
      tab_bar_align = "center";
      active_tab_background = "#${colors.gruvm.orange}";
      inactive_tab_background = "#${colors.gruvm.red}";
      active_border_color = "#${colors.gruvm.green}";
      inactive_border_color = "#${colors.gruvm.aqua}";
    };
    keybindings = {"alt+shift+tab" = "no_op";};
    shellIntegration.enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      tp = "trash put";
      btm = "btm --theme gruvbox ";
      neofetch = "fastfetch";
      icat = "kitty icat";
      pkgsearch = "nix search nixpkgs";
      rebuild = "sudo nixos-rebuild switch --flake /home/lisan/nix/config#default";
    };
    interactiveShellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      set -g fish_greeting

      function y
      	set tmp (mktemp -t "yazi-cwd.XXXXXX")
      	yazi $argv --cwd-file="$tmp"
      	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      		builtin cd -- "$cwd"
      	end
      	rm -f -- "$tmp"
      end
    '';
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
    };
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main.font = "JetBrains Mono NF";
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}

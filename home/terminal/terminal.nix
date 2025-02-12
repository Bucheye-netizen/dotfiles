{...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "100";
  };

  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkMedium";
    font = {
      size = 8;
      name = "JetBrainsMono Nerd Font";
    };
    settings = {
      tab_bar_style = "powerline";
      cursor_trail = 1;
      touch_scroll_multiplier = 2.0;
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

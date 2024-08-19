{ ... }: {
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Medium";
    font = {
      size = 9;
      name = "JetBrainsMono Nerd Font";
    };
    settings = { tab_bar_style = "powerline"; };
    keybindings = { "alt+shift+tab" = "no_op"; };
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      rm = "trash put";
      btm = "btm --color gruvbox ";
      neofetch = "fastfetch";
      icat = "kitty icat";
      pkgsearch = "nix search nixpkgs";

      rebuild =
        "sudo nixos-rebuild switch --flake /home/lisan/.config/nix#default";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}

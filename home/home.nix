{ pkgs, nixvim, hyprcursor, ags, ... }:

let
  colors = import ./util/colors.nix;
  stateVersion = "24.05";
  # gtk-material-theme = import ../derivations/gtk-theme.nix { inherit pkgs; };
in {
  imports = [
    nixvim.homeManagerModules.nixvim
    ./modules/vscode.nix
    ./modules/hyprland.nix
    ./modules/nvim.nix
    ./modules/terminal/terminal.nix
    ags.homeManagerModules.default
  ];
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";
  home.stateVersion = stateVersion;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  xdg.mimeApps.defaultApplications = { "application/pdf" = "firefox.desktop"; };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    source-serif-pro
    hyprpaper
    gruvbox-dark-icons-gtk
    gruvbox-plus-icons
    alejandra
    hyprcursor.packages.${pkgs.system}.default
    nil
    (texlive.combine {
      inherit (texlive)
        scheme-medium latexmk titlesec booktabs multirow chngcntr enumitem
        xcharter stix2-otf;
    })
  ];

  home.pointerCursor = {
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Gruvbox)";
    size = 24;
    gtk.enable = true;
  };

  home.sessionVariables = {

  };

  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
  fonts.fontconfig.defaultFonts.serif = [ "Source Serif Pro" ];

  home.file = { };

  programs.home-manager.enable = true;
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
  };

  programs.git = {
    enable = true;
    userName = "Lisan";
    userEmail = "lisan.kontra@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.waybar = { enable = true; };

  programs.fuzzel = {
    enable = true;
    settings = with colors; {
      colors.background = "${gruvm.bg0}ff";
      colors.text = "${gruvm.fg0}ff";
      colors.selection = "${gruvm.bg1}ff";
      colors.selection-text = "${gruvm.fg0}ff";
      colors.selection-match = "${gruvm.orange}ff";
      colors.border = "${gruvm.bg1}ff";
      border.width = 4;
      main.icon-theme = "Gruvbox-Plus-Dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-gtk-theme;
      name = "Gruvbox-Dark";
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Capitaine Cursors (Gruvbox)";
        cursor-size = 24;
      };
    };
  };

  programs.ags = {
    enable = true;
    # configDir = ./ags;
  };

  programs.neomutt.enable = true;
}

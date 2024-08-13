{ pkgs, inputs, ... }:

let
  colors = import ./util/colors.nix;
  stateVersion = "24.05";
  gtk-material-theme = import ./derivations/gtk-theme.nix { inherit pkgs; };
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./modules/dunst.nix
    (import ./modules/firefox.nix { inherit stateVersion; })
    ./modules/vscode.nix
    ./modules/hyprland.nix
    ./modules/nvim.nix
    ./modules/terminal/terminal.nix
    inputs.ags.homeManagerModules.default
  ];
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";
  home.stateVersion = stateVersion;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    source-serif-pro
    hyprpaper
    gruvbox-dark-icons-gtk
    gruvbox-plus-icons
    nixfmt-classic
    inputs.hyprcursor.packages.${pkgs.system}.default
    nil
  ];

  home.pointerCursor = {
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Gruvbox)";
    size = 18;
    gtk.enable = true;
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
  fonts.fontconfig.defaultFonts.serif = [ "Source Serif Pro" ];

  home.file = { };

  programs.home-manager.enable = true;
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "gruvbox-material-dark";
      package = gtk-material-theme;
    };
  };

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Lisan";
    userEmail = "lisan.kontra@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.waybar = { enable = true; };

  programs.fuzzel = {
    enable = true;
    settings = {
      colors.background = "${colors.toHypr colors.gruv.dark1}ff";
      colors.text = "${colors.toHypr colors.gruv.light1}ff";
      colors.selection = "${colors.toHypr colors.gruv.dark4}ff";
      colors.selection-text = "${colors.toHypr colors.gruv.light2}ff";
      colors.selection-match = "${colors.toHypr colors.gruv.faded_orange}ff";
      colors.border = "${colors.toHypr colors.gruv.dark3}ff";
      border.width = 2;
      main.icon-theme = "Gruvbox-Plus-Dark";
    };
  };
  gtk = {
    enable = true;
    theme = {
      package = gtk-material-theme;
      name = "gruvbox-material-dark";
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    };
  };

  programs.ags = {
    enable = true;
    configDir = ./ags;
  };
}

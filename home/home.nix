{
  pkgs,
  hyprcursor,
  ...
}: let
  colors = import ./util/colors.nix;
  stateVersion = "24.05";
in {
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";
  home.stateVersion = stateVersion;
  nixpkgs.config.allowUnfree = true;
  xdg.mimeApps.defaultApplications = {"firefox.desktop" = "application/pdf";};
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-configtool
      fcitx5-m17n
    ];
  };

  home.packages = with pkgs; [
    source-serif-pro
    nerd-fonts.jetbrains-mono
    hyprpaper
    gruvbox-plus-icons
    breeze-icons
    alejandra
    hyprcursor.packages.${pkgs.system}.default
    nixd
    (texlive.combine {
      inherit
        (texlive)
        scheme-medium
        latexmk
        titlesec
        booktabs
        multirow
        chngcntr
        enumitem
        xcharter
        stix2-otf
        ;
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

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["JetBrainsMono NF"];
    defaultFonts.serif = ["Source Serif Pro"];
  };

  home.file = {};

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

  programs.waybar = {enable = true;};

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
      package = pkgs.gruvbox-plus-icons;
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
  };

  programs.neomutt.enable = true;
}

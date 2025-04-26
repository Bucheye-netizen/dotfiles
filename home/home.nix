{
  pkgs,
  hyprcursor,
  config,
  ...
}: let
  colors = import ./util/colors.nix;
  stateVersion = "24.05";
in {
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";
  home.stateVersion = stateVersion;
  nixpkgs.config.allowUnfree = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-configtool
        fcitx5-m17n
        fcitx5-nord
      ];
    };
  };

  home.packages = with pkgs; [
    hyprpaper
    gruvbox-plus-icons
    alejandra
    gruvbox-gtk-theme
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
        colophon
        fira
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

  home.file = {};

  programs.home-manager.enable = true;
  qt = {
    platformTheme.name = "gtk";
    enable = true;
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
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/desktop";
    download = "${config.home.homeDirectory}/downloads";
    documents = "${config.home.homeDirectory}/documents";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
    templates = "${config.home.homeDirectory}/templates";
    publicShare = "${config.home.homeDirectory}/public";
    music = "${config.home.homeDirectory}/music";
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    settings = {
      global = {
        notification_limit = 5;
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#${colors.gruvm.orange}";
        frame_width = 2;
        background = "#${colors.gruvm.bg0}";
        foreground = "#${colors.gruvm.fg0}";
        corner_radius = 5;
      };

      urgency_critical = {
        frame_color = "#${colors.gruvm.red}";
      };

      urgency_low = {
        frame_color = "#${colors.gruvm.bg1}";
        foreground = "#${colors.gruvm.fg1}";
      };
    };
  };

  home.file = {
    ".config/hyprswitch.css" = {
      text = builtins.readFile ./hyprswitch.css;
      executable = false;
    };
  };
}

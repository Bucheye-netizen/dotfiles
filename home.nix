{ pkgs, inputs, ... }:

let
  colors = import ./colors.nix;
  stateVersion = "24.05";
  # gtk-material-theme = pkgs.stdenv.mkDerivation {
  #   name = "gtk-theme";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "TheGreatMcPain";
  #     repo = "gruvbox-material-gtk";
  #     rev = "808959bcfe8b9409b49a7f92052198f0882ae8bc";
  #     sha256 = "sha256-NHjE/HI/BJyjrRfoH9gOKIU8HsUIBPV9vyvuW12D01M=";
  #   };
  #   propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];

  #   installPhase = ''
  #     		runHook preInstall
  #     		mkdir -p $out/share/themes/gruvbox-material-dark
  #         rm -rf README.md LICENSE icons themes/Gruvbox-Material-Dark-HIDPI
  #         cp -r themes/Gruvbox-Material-Dark/* $out/share/themes/gruvbox-material-dark
  #     		runHook preInstall
  #   '';
  # };
  gtk-material-theme = import ./gtk-theme.nix { inherit pkgs; };
in {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
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
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
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
        "col.active_border" = "rgb(${colors.toHypr colors.gruv.dark2})";
        "col.inactive_border" = "rgb(${colors.toHypr colors.gruv.dark1})";
        border_size = 2;
      };
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
        "SUPER, T, togglefloating"
        "SUPER, W, killactive"
        "SUPER, F, fullscreen"
        "SUPER, K, fakefullscreen"
        "SUPER, M, fullscreen, 1"
        "SUPER, C, centerwindow"
      ];
      exec-once = [ "hyprctl setcursor 'Capitaine Cursors (Gruvbox)' 18" ];
      bindm =
        [ "SUPER, mouse:273, resizewindow" "SUPER, mouse:272, movewindow" ];
      windowrulev2 = [
        # "opacity 0.8 0.7,class:^(org.gnome.Nautilus)"
        # "opacity 0.9 0.8,class:^(code-url-handler)"
        # "opacity 0.8 0.7,class:^(kitty)"
        "float,class:^(org.gnome.Nautilus)"
        "float,class:^(.blueman-manager-wrapped)"
        # "opacity 0.8 0.7,class:^(.blueman-manager-wrapped)"
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
        "sudo nixos-rebuild switch --flake /home/lisan/.config/nixos#default";
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

  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Lisan";
    userEmail = "lisan.kontra@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.nixvim = {
    enable = true;
    colorscheme = "gruvbox-material";
    extraPlugins = with pkgs.vimPlugins; [ gruvbox-material-nvim ];
    plugins = {
      treesitter = {
        enable = true;

        settings = {
          ensure_installed = [ "c" "rust" "cpp" "nix" "kdl" ];
          highlight.enable = true;
        };

        nixGrammars = true;
      };
      fzf-lua.enable = true;
    };

    keymaps = [{
      mode = "i";
      key = "kj";
      action = "<Esc>";
    }];
    opts = {
      shiftwidth = 2;
      tabstop = 2;
      clipboard = "unnamedplus";
      autoindent = true;
      number = true;
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.waybar = { enable = true; };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        vscodevim.vim
        jdinhlife.gruvbox
        rust-lang.rust-analyzer
        llvm-vs-code-extensions.vscode-clangd
        bbenoist.nix
        jnoortheen.nix-ide
        tamasfe.even-better-toml
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "gruvbox-material";
          publisher = "sainnhe";
          version = "6.5.1";
          sha256 = "sha256-D+SZEQQwjZeuyENOYBJGn8tqS3cJiWbEkmEqhNRY/i4";
        }
        {
          name = "magic-racket";
          publisher = "evzen-wybitul";
          version = "0.6.7";
          sha256 = "sha256-1A4j8710AYuV8gA+sybv6WSavPVcCPMvI71h4n4Jx0w=";
        }
        {
          name = "vscode-nushell-lang";
          publisher = "TheNuProjectContributors";
          version = "1.9.0";
          sha256 = "sha256-E9CK/GChd/yZT+P3ttROjL2jHtKPJ0KZzc32/nbuE4w";
        }
        {
          name = "gruvbox-material-icon-theme";
          publisher = "JonathanHarty";
          version = "1.1.5";
          sha256 = "sha256-86UWUuWKT6adx4hw4OJw3cSZxWZKLH4uLTO+Ssg75gY=";
        }
      ];
    userSettings = {
      "nix.serverSettings" = {
        "nil" = { "formatting" = { "command" = [ "nixfmt" ]; }; };
      };

      "workbench.colorTheme" = "Gruvbox Material Dark";
      "editor.fontFamily" = "JetBrainsMonoNerdFont, monospace";
      "gruvboxMaterial.darkPalette" = "original";
      "gruvboxMaterial.darkContrast" = "hard";
      "gruvboxMaterial.highContrast" = true;
      "vim.insertModeKeyBindings" = [{
        "before" = [ "k" "j" ];
        "after" = [ "<Esc>" ];
      }];
      "workbench.activityBar.location" = "hidden";
      "workbench.panel.defaultLocation" = "right";
      "editor.wordWrap" = "on";
      "editor.fontSize" = 14;
      "terminal.integrated.fontSize" = 12;
      "window.titleBarStyle" = "custom";
      "window.customTitleBarVisibility" = "windowed";
      "window.menuBarVisibility" = "toggle";
      "window.zoomLevel" = -1;
      "editor.minimap.enabled" = false;
      "zenMode.showTabs" = "none";
      "editor.formatOnSave" = true;
      "editor.inlayHints.enabled" = "offUnlessPressed";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "workbench.iconTheme" = "gruvbox-material-icon-theme";
      "editor.guides.indentation" = false;
    };
    keybindings = [
      {
        "key" = "ctrl+alt k";
        "command" = "workbench.action.toggleZenMode";
        "when" = "!isAuxiliaryWindowFocusedContext";
      }

      {
        "key" = "ctrl+p";
        "command" = "-extension.vim_ctrl+p";
        "when" =
          "editorTextFocus && vim.active && vim.use<C-p> && !inDebugRepl || vim.active && vim.use<C-p> && !inDebugRepl && vim.mode == 'CommandlineInProgress' || vim.active && vim.use<C-p> && !inDebugRepl && vim.mode == 'SearchInProgressMode'";
      }

      {
        "key" = "alt+j alt+j";
        "command" = "workbench.action.toggleActivityBarVisibility";
      }

      {
        "key" = "ctrl+alt+k";
        "command" = "workbench.action.toggleZenMode";
        "when" = "!isAuxiliaryWindowFocusedContext";
      }

      {
        "key" = "ctrl+k z";
        "command" = "-workbench.action.toggleZenMode";
        "when" = "!isAuxiliaryWindowFocusedContext";
      }
    ];
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      colors.background = "${colors.toHypr colors.gruv.dark0_hard}C8";
      colors.text = "${colors.toHypr colors.gruv.light1}ff";
      colors.selection = "${colors.toHypr colors.gruv.dark4}ff";
      colors.selection-text = "${colors.toHypr colors.gruv.light2}ff";
      colors.selection-match = "${colors.toHypr colors.gruv.faded_orange}ff";
      colors.border = "${colors.toHypr colors.gruv.neutral_orange}ff";
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

  programs.firefox = {
    enable = true;
    profiles.lisan = {
      bookmarks = [{
        name = "Blogs";
        toolbar = true;
        bookmarks = [
          {
            name = "vaxry";
            tags = [ "vaxry" "blog" ];
            url = "http://vaxry.net/";
          }
          {
            name = "fasterthanlime";
            tags = [ "fasterthanlime" "blog" ];
            url = "https://fasterthanli.me/";
          }
        ];
      }];

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          }];
        };
        "Home Manager Options" = {
          urls = [{
            template = "https://home-manager-options.extranix.com/";
            params = [
              {
                name = "release";
                value = "release-${stateVersion}";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@hmo" ];
          }];
        };
      };

      search.force = true;
    };
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    settings = {
      global = {
        notification_limit = 5;
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "${colors.gruv.light4}";
        frame_width = 1;
        background = "${colors.gruv.dark1}";
        corner_radius = 3;
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    };
  };
}

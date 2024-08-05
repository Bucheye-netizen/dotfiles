{ pkgs, inputs, ... }:

let
  colors = import ./colors.nix;
in {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    source-serif-pro
    hyprpaper
    gruvbox-gtk-theme
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
  };

  home.sessionVariables = { 
    TERMINAL = "kitty"; 
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
  fonts.fontconfig.defaultFonts.serif = [ "Source Serif Pro" ];

  home.file = { };

  services.pueue.enable = true;
  programs.home-manager.enable = true;

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
        inactive_opacity = 0.85;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      general = {
        gaps_out = 10;
        sensitivity = 0.4;
        "col.active_border" = ("rgb(${colors.toHypr colors.gruv.bright_orange})"
          + " rgb(${colors.toHypr colors.gruv.bright_red})");

        "col.inactive_border" = ("rgb(${colors.toHypr colors.gruv.faded_aqua})"
          + " rgb(${colors.toHypr colors.gruv.faded_blue})");
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
      exec-once = [
        "hyprctl setcursor 'Capitaine Cursors (Gruvbox)' 18"
      ];
      bindm =
        [ "SUPER, mouse:273, resizewindow" "SUPER, mouse:272, movewindow" ];
      windowrulev2 = [
        "opacity 0.8 0.7,class:^(thunar)"
        "opacity 0.9 0.8,class:^(code-url-handler)"
        "opacity 0.8 0.7,class:^(kitty)"
        "float,class:^(thunar)"
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
    theme = "Gruvbox Dark Hard";
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
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast = "hard";
        terminal_colors = true;
      };
    };
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
        brettm12345.nixfmt-vscode
				jnoortheen.nix-ide
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
					version ="1.9.0";
					sha256 = "sha256-E9CK/GChd/yZT+P3ttROjL2jHtKPJ0KZzc32/nbuE4w";
				}
      ];
    userSettings = {
      "workbench.colorTheme" = "Gruvbox Dark Hard";
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
			"nix.formatterPath" = "nixpkgs-fmt";
			"nix.enableLanguageServer" = true;
			"nix.serverPath" = "nil";
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
      colors.background = "${colors.toHypr colors.gruv.dark0_hard}ff";
      colors.text = "${colors.toHypr colors.gruv.light1}ff";
      colors.selection = "${colors.toHypr colors.gruv.dark4}ff";
      colors.selection-text = "${colors.toHypr colors.gruv.light2}ff";
      colors.selection-match = "${colors.toHypr colors.gruv.faded_orange}ff";
      colors.border = "${colors.toHypr colors.gruv.bright_orange}ff";
      main.icon-theme = "Gruvbox-Plus-Dark";
    };
  };
}

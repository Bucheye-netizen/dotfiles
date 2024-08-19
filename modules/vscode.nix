{ pkgs, ... }: {
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
        esbenp.prettier-vscode
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "gruvbox-material";
          publisher = "sainnhe";
          version = "6.5.2";
          sha256 = "sha256-+JU/pwIFmrH8wXqC9hh59iJS22zs7ITYhEwWf676RJU=";
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
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
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

}

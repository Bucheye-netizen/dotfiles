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
        mesonbuild.mesonbuild
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "flutter";
          publisher = "Dart-Code";
          version = "3.99.20240930";
          sha256 = "sha256-CxamDT8/Q5wOhcRYA4wl2W2km8ymdkoTGlt0z+HwFPI=";
        }
        {
          name = "gruvbox-material";
          publisher = "sainnhe";
          version = "6.5.2";
          sha256 = "sha256-D+SZEQQwjZeuyENOYBJGn8tqS3cJiWbEkmEqhNRY/i4=";
        }
        {
          name = "magic-racket";
          publisher = "evzen-wybitul";
          version = "0.6.7";
          sha256 = "sha256-1A4j8710AYuV8gA+sybv6WSavPVcCPMvI71h4n4Jx0w=";
        }
        {
          name = "tera";
          publisher = "karunamurti";
          version = "0.0.9";
          sha256 = "sha256-e72lZXg//vCZwoggRrpJlYiNUMxID3rkDLLBtV1b098=";
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
        {
          name = "latex-workshop";
          publisher = "James-Yu";
          sha256 = "sha256-modm0+XhYltiXOodPpkzNA9llp5/7oVUbpSNdbpMHCY=";
          version = "10.1.0";
        }
      ];
    userSettings = {
      "nix.serverSettings" = {
        "nil" = { "formatting" = { "command" = [ "nixfmt" ]; }; };
      };

      "workbench.colorTheme" = "Gruvbox Material Dark";
      "editor.fontFamily" = "JetBrainsMonoNerdFont, monospace";
      "gruvboxMaterial.darkPalette" = "mix";
      "gruvboxMaterial.darkContrast" = "medium";
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
      "terminal.integrated.enableMultiLinePasteWarning" = false;
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
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "editor.formatOnSave" = true;
      };
      "mesonbuild.downloadLanguageServer" = false;

      "latex-workshop.latex.recipes" = [
        {
          "name" = "latexmk (lualatex)";
          "tools" = [ "lualatexmk" ];
        }

        {
          "name" = "latexmk";
          "tools" = [ "latexmk" ];
        }
        {
          "name" = "latexmk (latexmkrc)";
          "tools" = [ "latexmk_rconly" ];
        }

        {
          "name" = "latexmk (xelatex)";
          "tools" = [ "xelatexmk" ];
        }
        {
          "name" = "pdflatex -> bibtex -> pdflatex * 2";
          "tools" = [ "pdflatex" "bibtex" "pdflatex" "pdflatex" ];
        }
        {
          "name" = "Compile Rnw files";
          "tools" = [ "rnw2tex" "latexmk" ];
        }
        {
          "name" = "Compile Jnw files";
          "tools" = [ "jnw2tex" "latexmk" ];
        }
        {
          "name" = "Compile Pnw files";
          "tools" = [ "pnw2tex" "latexmk" ];
        }
        {
          "name" = "tectonic";
          "tools" = [ "tectonic" ];
        }
      ];
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

{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    colorscheme = "gruvbox-material";
    extraPlugins = with pkgs.vimPlugins; [gruvbox-material-nvim];
    plugins = {
      comment = {
        enable = true;
        autoLoad = true;
      };
      lz-n.enable = true;
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
        nixGrammars = true;

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          markdown
          nix
          toml
          c
          cpp
          rust
          git-config
          git-rebase
          gitcommit
          vimdoc
          typescript
          json
        ];
        lazyLoad.enable = true;
        lazyLoad.settings.event = "BufRead";
      };
      guess-indent.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            javascript = ["prettierd"];
            nix = ["alejandra"];
            rust = ["rustfmt"];
            c = ["clang-format"];
            cpp = ["clang-format"];
          };
          format_on_save = ''{lsp_format = "fallback", timeout_ms = 500}'';
        };
      };
      fzf-lua = {
        enable = true;
        keymaps = {
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Fzf-Lua Git Files";
              silent = true;
            };
            settings = {winopts = {height = 0.7;};};
          };
          "<C-l>" = "live_grep_native";
        };
      };
    };

    opts = {
      shiftwidth = 2;
      tabstop = 2;
      clipboard = "unnamedplus";
      autoindent = true;
      number = true;
      ignorecase = true;
      showcmd = false;
      ruler = false;
    };
  };
}

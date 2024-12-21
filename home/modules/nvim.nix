{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    colorscheme = "gruvbox-material";
    extraPlugins = with pkgs.vimPlugins; [gruvbox-material-nvim];
    plugins = {
      treesitter = {
        enable = true;

        settings = {
          ensure_installed = ["c" "rust" "cpp" "nix" "kdl" "javascript" "haskell"];
          highlight.enable = true;
        };

        nixGrammars = true;
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
      neogit.enable = true;
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

    extraConfigLua = ''
      vim.loader.enable()
    '';

    # keymaps = [
    #   {
    #     mode = "i";
    #     key = "kj";
    #     action = "<Esc>";
    #   }
    # ];
    opts = {
      shiftwidth = 2;
      tabstop = 2;
      clipboard = "unnamedplus";
      autoindent = true;
      number = true;
      ignorecase = true;
    };
  };
}

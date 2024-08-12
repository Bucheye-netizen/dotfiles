{ pkgs, ... }: {
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
      conform-nvim = {
        enable = true;
        formattersByFt = {
          javascript = [ "prettierd" ];
          nix = [ "nixfmt" ];
          rust = [ "rustfmt" ];
        };
				formatOnSave = ''{
					lsp_format = "fallback",
					timeout_ms = 500,
				}'';
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
            settings = { winopts = { height = 0.7; }; };
          };
          "<C-l>" = "live_grep";
        };
      };
    };

    extraConfigLua = ''
      vim.loader.enable()
    '';

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
}

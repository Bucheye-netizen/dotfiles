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
}

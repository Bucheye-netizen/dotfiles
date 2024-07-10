{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";

  home.stateVersion = "24.05";

  home.packages = [
  ];

  home.file = {

  };


  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  programs.home-manager.enable = true;
  # wayland.windowManager.hyprland.enable = true;
  programs.git = {
    enable = true;
    userName  = "Lisan";
    userEmail = "lisan.kontra@gmail.com";
  };


  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    plugins.treesitter = {
      enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };
    keymaps = [
      {
        mode = "i";
        key = "kj";
        action = "<Esc>";
      }
    ];
    opts = {
      shiftwidth = 4;
    };
  };
}

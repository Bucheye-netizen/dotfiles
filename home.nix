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
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      bind = [
        "SUPER,Q,exec,kitty"
	"SUPER, X, exec, firefox"
      ];
    };
  };

  programs.waybar.enable = true;
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark Hard";
  };

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
      {
        mode = "n";
	key = "<C-v>";
	action = ":call system(\"wl-copy\", @\")<CR>";
      }
    ];
    opts = {
      shiftwidth = 4;
    };
  };
}

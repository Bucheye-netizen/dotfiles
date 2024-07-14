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
    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 0.9;
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_poewr = 3;
      blur = {
	enabled = true; 
	size = 3;
	passes = 1;
	vibrancy = 0.1696;
     };
    };
    settings = {
      bind = [
        "SUPER,Q,exec,kitty"
	"SUPER, X, exec, firefox"
	"ALT, Tab, cyclenext"
	"ALT, Tab, bringactivetotop"
	"SUPER, T, togglefloating"
      ];
      bindm = [
	"SUPER_SHIFT, mouse:272, resizewindow"
	"SUPER, mouse:272, movewindow"
      ];
    };
  };

  programs.waybar.enable = true;
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark Hard";
  };
  programs.nushell = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
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
	action = ":call system(\"wl-paste\", @\")<CR>";
      }
    ];
    opts = {
      shiftwidth = 4;
    };
  };
}

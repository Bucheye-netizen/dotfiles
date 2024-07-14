{ config, pkgs, inputs, ... }:

let rootPath = ../.; in 
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.username = "lisan";
  home.homeDirectory = "/home/lisan";

  home.stateVersion = "24.05";

  fonts.fontconfig.enable = true;

  home.packages = [
    (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
  ];
  fonts.fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font"];

  home.file = {

  };

  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
		settings = {
			decoration = {
				rounding = 10;
				active_opacity = 1.0;
				inactive_opacity = 0.9;
				drop_shadow = true;
				shadow_range = 4;
				shadow_render_power = 3;
				blur = {
					enabled = true; 
					size = 3;
					passes = 1;
					vibrancy = 0.1696;
				};
			};
		};


    settings = {
      bind = [
				"SUPER,Q,exec,kitty"
				"SUPER, X, exec, firefox"
				"ALT, Tab, cyclenext"
				"ALT, Tab, bringactivetotop"
				"SUPER, T, togglefloating"
				"SUPER, W, closewindow"
				"SUPER, F, fullscreen"
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
		font = {
			size = 9;
			name = "JetBrainsMono Nerd Font";
		};
		keybindings = {
			"ctrl+t" = "new_tab";
			"ctrl+w" = "close_tab";
			"ctrl+alt" = "next_tab";
			"ctrl+shift+alt" = "previous_tab";
		};
		settings = {
			tab_bar_style = "powerline";
		};
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
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

  programs.git = {
    enable = true;
    userName  = "Lisan";
    userEmail = "lisan.kontra@gmail.com";
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
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
			fzf-lua.enable = true;
    };

    keymaps = [
      {
        mode = "i";
        key = "kj";
        action = "<Esc>";
      }
    ];
    opts = {
      shiftwidth = 2;
      tabstop = 2;
      clipboard = "unnamedplus";
      autoindent = true;
    };
  };
}

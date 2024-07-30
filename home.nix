{ config, pkgs, inputs, self, ... }:

let 
	rootPath = ../.; 
	colors = import ./colors.nix;
in 
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
	home.username = "lisan";
  home.homeDirectory = "/home/lisan";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
		hyprpaper
		gruvbox-gtk-theme
  ];

  fonts.fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font"];

  home.file = {
  };

	services.pueue.enable = true;
  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
		settings = {
			misc = {
				disable_splash_rendering = true;
				disable_hyprland_logo = true;
			};
			decoration = {
				rounding = 5;
				active_opacity = 1.0;
				inactive_opacity = 0.85;
				drop_shadow = true;
				shadow_range = 4;
				shadow_render_power = 3;
				blur = {
					enabled = true; 
					size = 8;
					passes = 1;
					vibrancy = 0.1696;
				};
			};
			general = {
				gaps_out = 10;
				sensitivity = 0.4;
				"col.active_border" = (
					"rgb(${colors.toHypr colors.gruv.bright_orange})" 
					+ " rgb(${colors.toHypr colors.gruv.bright_red})"
				);

				"col.inactive_border" = (
					"rgb(${colors.toHypr colors.gruv.faded_aqua})" 
					+ " rgb(${colors.toHypr colors.gruv.faded_blue})"
				);
			};
		};

    settings = {
      bind = [
				"SUPER,Q,exec,kitty"
				"SUPER, R, exec, tofi-drun"
				"SUPER, X, exec, firefox"
				"SUPER, Tab, cyclenext"
				"SUPER, Tab, bringactivetotop"
				"SUPER, T, togglefloating"
				"SUPER, W, killactive"
				"SUPER, F, fullscreen"
				"SUPER, K, fakefullscreen"
				"SUPER, M, fullscreen, 1"
				"SUPER, C, centerwindow"
      ];
      bindm = [
				"SUPER, mouse:273, resizewindow"
				"SUPER, mouse:272, movewindow"
      ];
			windowrule = [
				"opacity 0.8 0.7,^(kitty)"
				"opacity 0.8 0.7,^(thunar)"
			];
    };
  };

	services.hyprpaper = {
		enable = true;
		settings =  {
      ipc = "off";
      splash = false;
			preload = ["${inputs.self}/wallpaper/gruvbox.png"];
			wallpaper = ["eDP-1,${inputs.self}/wallpaper/gruvbox.png"];
		};
	};

  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark Hard";
		font = {
			size = 9;
			name = "JetBrainsMono Nerd Font";
		};
		settings = {
			tab_bar_style = "powerline";
		};
		keybindings = {
			"alt+shift+tab" = "no_op";
		};
  };

	programs.tofi = {
		enable = true;
		settings = {
			# Inspired by https://github.com/iruzo/gruvbox-tofi/blob/main/gruvbox-dark
			text-color = "${colors.toHypr colors.gruv.light1}";
			prompt-color = "${colors.toHypr colors.gruv.bright_red}";
			selection-color = "${colors.toHypr colors.gruv.bright_yellow}";
			background-color = "${colors.toHypr colors.gruv.dark0_hard}";
			outline-width = 0;
			border-width = 0;
			font-size = 15;
			font = "JetBrainsMono Nerd Font";
			corner-radius = 10;
			width = "30%";
			height = "40%";
			drun-launch = true;
		};
	};

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
			rm = "trash put";
			btm = "btm --color gruvbox ";
			neofetch = "fastfetch";
			icat = "kitty icat";

			rebuild = "sudo nixos-rebuild switch --flake /home/lisan/.config/nixos#default";
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

	programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName  = "Lisan";
    userEmail = "lisan.kontra@gmail.com";
		extraConfig.init.defaultBranch = "main";
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

				settings = {
					ensure_installed = [
						"c"
						"rust"
						"cpp"
						"nix"
						"kdl"
					];
					highlight.enable = true;
				};

				nixGrammars = true;
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
			number = true;
    };
  };

	programs.tmux = {
		enable = true;
		extraConfig = builtins.readFile ./tmux.conf;
	};

	programs.waybar = {
		enable = true;
	};

	# gtk = {
	# 	enable = true;
	# 		package = pkgs.gruvbox-gtk-theme; 
	# 		name = "gtk-Dark";
	# 	};
	# };
}

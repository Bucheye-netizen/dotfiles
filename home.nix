{ config, pkgs, inputs, self, zjstatus, ... }:

let 
	rootPath = ../.; 
in 
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

	nixpkgs.overlays = with inputs; [
		(final: prev: {
			zjstatus = zjstatus.packages.${prev.system}.default; # adding pkgs.
		})
		zjstatus
	];

	# Colors

  programs.home-manager.enable = true;

	programs.zellij = {
		enable = true;
		settings = {
			simplified_ui = true;
			pane_frames = false;
			mouse_mode = true;
			default_layout = "${inputs.self}/zellij/layouts/simple.kdl";
			theme_dir = "${inputs.self}/zellij/themes";
			layout_dir = "${inputs.self}/zellij/layouts";
			ui.pane_frames.hide_session_name = true;
			theme = "gruvbox-dark";
		};
	};

  wayland.windowManager.hyprland = {
    enable = true;
		settings = {
			decoration = {
				rounding = 5;
				active_opacity = 1.0;
				inactive_opacity = 0.95;
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
			};
		};

    settings = {
      bind = [
				"SUPER,Q,exec,kitty"
				"SUPER, X, exec, firefox"
				"SUPER, Tab, cyclenext"
				"SUPER, Tab, bringactivetotop"
				"SUPER, T, togglefloating"
				"SUPER, W, killactive"
				"SUPER, F, fullscreen"
				"SUPER, K, fakefullscreen"
			  # maximizing windows without eliminating tab bar
				"SUPER, M, fullscreen, 1"
				"SUPER, C, centerwindow"
      ];
      bindm = [
				"SUPER, mouse:273, resizewindow"
				"SUPER, mouse:272, movewindow"
      ];
			windowrule = [
				"opacity 0.95 0.9,^(kitty)"
			];
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

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
			rm = "trash put";
			btm = "btm --color gruvbox ";

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
}

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
				rounding = 5;
				active_opacity = 1.0;
				inactive_opacity = 0.95;
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
			number = true;
    };
  };

	# Inspired by https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
	programs.tmux = {
		enable = true;
		extraConfig = ''
			unbind C-b
			unbind '"'
			unbind %
			unbind n
			unbind x
			unbind p

			set-option -g mouse on
			set-option -g prefix C-j

			bind-key C-j send-prefix
			bind i split-window -h
			bind v split-window -v

			bind -n M-w select-pane -U
			bind -n M-a select-pane -L
			bind -n M-s select-pane -D
			bind -n M-d select-pane -R

			bind -n M-Tab select-window -n
			bind -n M-S-Tab select-window -p

			bind -n C-w kill-window
			bind -n C-t new-window

			# DESIGN TWEAKS
			set -g default-terminal "tmux-256color"

			# don't do anything when a 'bell' rings
			set -g visual-activity off
			set -g visual-bell off
			set -g visual-silence off
			setw -g monitor-activity off
			set -g bell-action none

			# clock mode
			setw -g clock-mode-colour colour1

			# copy mode
			setw -g mode-style 'fg=colour1 bg=colour18 bold'

			# pane borders
			set -g pane-border-style 'fg=colour1'
			set -g pane-active-border-style 'fg=colour3'

			# statusbar
			set -g status-position 
			set -g status-justify left
			set -g status-style 'fg=colour5'
			set -g status-left '''
			set -g status-right '%Y-%m-%d %H:%M '
			set -g status-right-length 50
			set -g status-left-length 10

			setw -g window-status-current-style 'fg=colour0 bg=colour4 bold'
			setw -g window-status-current-format ' #I #W #F '

			setw -g window-status-style 'fg=colour1 dim'
			setw -g window-status-format ' #I #[fg=colour7]#W #[fg=colour1]#F '

			setw -g window-status-bell-style 'fg=colour2 bg=colour1 bold'

			# messages
			set -g message-style 'fg=colour2 bg=colour0 bold'
		'';
	};
}




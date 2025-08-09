{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["nvidia-drm.fbdev=1" "usbcore.autosuspend=-1"];
  boot.kernelModules = ["amdgpu"];

  security.polkit.enable = true;

  nix.optimise.automatic = true;
  nix.optimise.dates = ["03:45"];

  qt.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enabling polkit_gnome
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = ["nvidia"];
  };

  # Loooking into dynamic boost also include maybe "amdgpu" as a kernel module
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };
  };

  fonts.packages = with pkgs; [
    source-serif-pro
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term
    lmodern
    noto-fonts
    stix-two
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["JetBrainsMono NF"];
    defaultFonts.serif = ["Source Serif Pro"];
    defaultFonts.sansSerif = ["Noto Sans"];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {LC_TIME = "en_US.UTF-8";};

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.dconf.enable = true;

  programs.uwsm.enable = true;

  environment.sessionVariables = {
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.java.enable = true;

  programs.fish.enable = true;

  programs.firefox.enable = true;

  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd \"uwsm start hyprland-uwsm.desktop\"";
      };
    };
  };

  users.users.bucheye = {
    isNormalUser = true;
    description = "Bucheye";
    extraGroups = ["networkmanager" "wheel" "input" "uinput" "audio"];
    packages = with pkgs; [
      mumble
      clang-tools
      nsnake
      kitty
      helix
      hyprpicker
      hyprpaper
      hypridle
      fuzzel
      trashy
      alejandra
      nixd
      yazi
      starship
      fzf
      ffmpeg
      poppler
      fd
      ripgrep
      resvg
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      google-chrome
      nitch
      prismlauncher
      brightnessctl
      rustup
      acpi
      gcc
      mpv
      m4
      gnumake
      eza
      calibre
      pulseaudio
      pavucontrol
      qbittorrent
      vlc
      hyprlock
      file
      font-manager
      meson
      mesonlsp
      ninja
      gpu-screen-recorder
      cmake
      stow
      btop
      fastfetch
      geekbench
      vesktop
      lazygit
      github-cli
      hyprshot
      zig
      zls
      foliate
      tokei
      cmake-format
      cmake-lint
      cmake-language-server
      qtcreator
      anki
      libreoffice
      glib
      usbutils
      gparted
      coreutils-full
      google-cloud-sdk
      nautilus
      gsettings-desktop-schemas
      gsettings-qt
      dconf-editor
      zip
      obsidian
      openrct2
      usbimager
      typst
      tinymist
      halloy
      waybar
      hyprpanel
      fractal
      gnome-keyring
      nzbget
      neomutt
      aerc
      thunderbird
      screen
      minicom
      vscode
      zed-editor
      nodejs
      powertop
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.gvfs.enable = true;
  services.kanata = {
    enable = true;
    keyboards = {
      "logi".config = ''
        (defsrc
          caps
        )

        (deflayer superior
          esc
        )
      '';
    };
  };

  services.expressvpn.enable = true;
  services.tor.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    man-pages
    man-pages-posix
    wl-clipboard
    inputs.quickshell.packages.${pkgs.system}.default
    kdePackages.qtdeclarative
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  system.stateVersion = "24.11";
}

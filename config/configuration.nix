{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Graphics
  hardware.graphics.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["nvidia-drm.fbdev=1"];
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = ["amdgpu" "nvidia"];
  };
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
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["JetBrainsMono NF"];
    defaultFonts.serif = ["Source Serif Pro"];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Addis_Ababa";
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
  programs.uwsm.enable = true;

  environment.sessionVariables = {
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
  };

  qt.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.java.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
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

  programs.fish.enable = true;

  users.users.lisan = {
    isNormalUser = true;
    description = "Lisan";
    extraGroups = ["networkmanager" "wheel" "input" "uinput"];
    packages = with pkgs; [
      inputs.hyprswitch.packages.x86_64-linux.default
      libva
      libva-utils
      glxinfo
      clinfo
      virtualglLib
      vulkan-loader
      vulkan-tools
      wget
      sl
      kitty
      libnotify
      lshw
      pciutils
      wl-clipboard
      tree
      htop
      trashy
      fzf
      nsnake
      gcc
      bottom
      clang-tools
      clang
      rustup
      openssl
      pkg-config
      swayimg
      foliate
      racket-minimal
      unzip
      newsflash
      obsidian
      nautilus
      hyprshot
      brightnessctl
      prettierd
      ripgrep
      bun
      libdbusmenu-gtk3
      ani-cli
      hyprpicker
      doggo
      vesktop
      mpv
      meson
      tldr
      coreutils-full
      man-pages
      cmake
      bemoji
      google-cloud-sdk
      amfora
      wtype
      gh
      fd
      sass
      lazygit
      powertop
      acpi
      maven
      dhcpcd
      vala
      qbittorrent
      lenovo-legion
      cbonsai
      (haskellPackages.ghcWithPackages
        (pkgs: [pkgs.stack pkgs.haskell-language-server]))
      ffmpeg
      inputs.hyprland-qtutils.packages."${pkgs.system}".default
      nitch
      google-chrome
      prismlauncher
      zip
      pavucontrol
      kdePackages.okular
      gnome-themes-extra
      evince
      font-manager
      conduwuit
      element-desktop
      element
      pomodoro
    ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

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

  environment.systemPackages = with pkgs; [neovim wget git];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  system.stateVersion = "24.11";
}

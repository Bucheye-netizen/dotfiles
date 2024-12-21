{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [
    pkgs.linuxKernel.packages.linux_6_6.lenovo-legion-module
  ];

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

  programs.hyprland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  environment.sessionVariables = {
    TERMINAL = "kitty";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  qt.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = ["amdgpu" "nvidia"];
  };

  # Getting gaming to work
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.java.enable = true;

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
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
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
      };
    };
  };

  programs.fish.enable = true;

  users.users.lisan = {
    isNormalUser = true;
    description = "Lisan";
    extraGroups = ["networkmanager" "wheel" "input" "uinput"];
    packages = with pkgs; [
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
      marker
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
      expressvpn
      lazygit
      powertop
      acpi
      browsh
      lynx
      maven
      dhcpcd
      vala
      lunar-client
      qbittorrent
      lenovo-legion
      cbonsai
      (haskellPackages.ghcWithPackages
        (pkgs: [pkgs.stack pkgs.haskell-language-server]))
      yazi
      ffmpeg
    ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

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

  system.stateVersion = "24.05";
}

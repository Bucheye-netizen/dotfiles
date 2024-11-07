{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "buchela";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  environment.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    TERMINAL = "kitty";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  hardware.graphics.enable = true;
  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      nvidiaBusId = "PCI:01:0:0";
      amdgpuBusId = "PCI:05:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  # services.expressvpn.enable = true;

  services.xserver = {
    xkb = {
      variant = "";
      layout = "us";
    };
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  services.displayManager.sddm = {
    enable = true;
    theme = "${import ../derivations/sddm-theme.nix { inherit pkgs; }}";
  };

  programs.hyprland.enable = true;
  programs.dconf.enable = true;

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects
    linuxKernel.packages.linux_6_11.acpi_call
  ];

  users.users.lisan = {
    isNormalUser = true;
    description = "Lisan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      wget
      sl
      kitty
      libnotify
      swww
      lshw
      pciutils
      flutter
      # androidStudioPackages.dev
      wl-clipboard
      tree
      vivid
      htop
      trashy
      fzf
      nsnake
      gcc
      fastfetch
      bottom
      cbonsai
      libgcc
      clang-tools
      clang
      rustup
      openssl
      pkg-config
      swayimg
      bk
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
      # mov-cli
      hyprpicker
      doggo
      vesktop
      mpv
      pavucontrol
      meson
      ninja
      tldr
      libreoffice
      coreutils-full
      man-pages
      cmake
      muon
      bemoji
      tofi
      neovide
      google-cloud-sdk
      amfora
      wtype
      lunar-client
      gh
      notion-app-enhanced
      bun
      fd
      sass
    ];
    shell = pkgs.nushell;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  programs.firefox.enable = true;
}

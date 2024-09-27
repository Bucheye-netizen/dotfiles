{ config, pkgs, ... }:

{
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
  };

  hardware.graphics.enable = true;
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
      # sync.enable = true;
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
  services.expressvpn.enable = true;

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
    theme = "${import ./derivations/sddm-theme.nix { inherit pkgs; }}";
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
    wget
    sl
    dunst
    kitty
    libnotify
    swww
    lshw
    pciutils
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
    expressvpn
    clang-tools
    clang
    rustup
    openssl
    pkg-config
    swayimg
    bk
    betterdiscordctl
    foliate
    racket-minimal
    unzip
    marker
    # Required for SDDM login theme to work. 
    libsForQt5.qt5.qtgraphicaleffects
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
    mov-cli
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
    tt
    google-cloud-sdk
  ];

  users.users.lisan = {
    isNormalUser = true;
    description = "Lisan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ amfora wtype ];
    shell = pkgs.nushell;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";

  powerManagement.enable = true;
  services.upower.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  services.gvfs.enable = true;
  programs.firefox.enable = true;
}

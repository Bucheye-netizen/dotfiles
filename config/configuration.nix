# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { LC_TIME = "en_US.UTF-8"; };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  programs.hyprland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  environment.sessionVariables = { TERMINAL = "kitty"; };

  services.xserver.enable = true;
  qt.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
  services.expressvpn.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" ];
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
      fastfetch
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
    ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [ neofetch neovim wget sl git fzf ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

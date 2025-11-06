{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  # For secure boot purposes.
  #
  # Remmeber this when installing on a new system.
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["nvidia-drm.fbdev=1" "usbcore.autosuspend=-1"];
  boot.kernelModules = ["amdgpu"];
  hardware.enableAllFirmware = true;

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
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = ["amdgpu" "nvidia"];
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
    cantarell-fonts
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
    defaultFonts.sansSerif = ["IosevkaTerm Nerd Font"];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # DC: America/New_York, RACINE: America/Chicago
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {LC_TIME = "en_US.UTF-8";};

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  programs.dconf.enable = true;
  programs.niri.enable = true;
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

  programs.wayfire = {
    enable = false;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      # wf-shell
      wayfire-shadows
      wayfire-plugins-extra
    ];
  };

  environment.sessionVariables = {
    TERMINAL = "kitty";
    NIXOS_OZONE_WL = "1";
    CHROME_EXECUTABLE = "google-chrome-stable";
    ANDROID_HOME = "${pkgs.androidenv.androidPkgs.androidsdk}";
    ANDROID_SDK_ROOT = "${pkgs.androidenv.androidPkgs.androidsdk}/libexec/android-sdk";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d";
    # fixing swing popups
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.java = {
    package = pkgs.jdk17;
    enable = true;
  };

  programs.fish.enable = true;

  programs.firefox.enable = true;
  programs.adb.enable = true;

  services.printing.enable = true;
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
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
        command = "${pkgs.greetd}/bin/agreety --cmd \"niri-session\"";
      };
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  users.users.bucheye = {
    isNormalUser = true;
    description = "Bucheye";
    extraGroups = ["networkmanager" "wheel" "input" "uinput" "audio" "dialout" "kvm" "adbusers"];
    packages = with pkgs; [
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
      starship
      ffmpeg
      # why do I have this installed on my user system?
      poppler
      fd
      ripgrep
      resvg
      google-chrome
      nitch
      prismlauncher
      brightnessctl
      rustup
      acpi
      gcc
      m4
      gnumake
      eza
      calibre
      pulseaudio
      pavucontrol
      qbittorrent
      vlc
      hyprlock
      font-manager
      meson
      mesonlsp
      ninja
      gpu-screen-recorder
      cmake
      stow
      btop
      fastfetch
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
      unzip
      obsidian
      usbimager
      typst
      tinymist
      halloy
      waybar
      hyprpanel
      fractal
      gnome-keyring
      nzbget
      thunderbird
      screen
      minicom
      vscode-fhs
      zed-editor
      nodejs
      powertop
      waybar
      killall
      dunst
      mullvad
      mullvad-vpn
      dig
      amfora
      evince
      jdt-language-server
      maven
      gnome-solanum
      jetbrains.idea-community
      bash-language-server
      shellcheck
      jj
      cpufetch
      binsider
      kalker
      wiki-tui
      libreoffice-fresh
      typstyle
      ty
      ruff
      uv
      devenv
      thonny
      jupyter
      conda
      pandoc
      zathura
      slack
      kdePackages.ghostwriter
      kdePackages.ksystemlog
      tombi
      jujutsu
      swayimg
      xwayland-satellite
      nix-tree
      capitaine-cursors
      baobab
      efibooteditor
      nixfmt
      nix-search-cli
      cpufrequtils
      bibtex-tidy
      texlab
      typora
      android-studio
      virt-manager
      flutter
      # android-tools
      mesa-demos
      jdk21
      androidenv.androidPkgs.androidsdk
      vulkan-tools
      wayfire
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.mullvad-vpn.enable = true;

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

  services.tor.enable = true;
  services.gpsd.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    man-pages
    man-pages-posix
    wl-clipboard
    sbctl
    efivar
    efibootmgr
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["bucheye"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  system.stateVersion = "24.11";
}

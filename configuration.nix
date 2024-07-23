{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pathfinder";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

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

  services.ivpn.enable = true;

  services.displayManager = {
    defaultSession = "hyprland";
    autoLogin.enable = true;
    autoLogin.user = "bryce";
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    autorun = true;
    xkb.layout = "us";
    xkb.variant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  xdg.portal.enable = true;

  hardware = {
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnails

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.blueman.enable = true;

  users.users.bryce = {
    isNormalUser = true;
    description = "bryce";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = with pkgs; [
    firefox
    vscode
    vlc
    inkscape
    ungoogled-chromium
    libreoffice
    zed-editor
    dolphin-emu
    clipgrab
    qbittorrent
    obsidian
    kitty

    brightnessctl
    bluez
    libdbusmenu-gtk3
    networkmanagerapplet # GUI
    zathura
    xfce.thunar
    pavucontrol
    libnotify
    lshw
    imgp
  
    _7zz
    unzip
    ripgrep
    xdragon
    croc
    gotop

    zig
    libgcc
    universal-ctags
    bun
    nodejs_22

    hyprland
    hyprlang
    waypaper
    swaybg
    rofi-wayland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
  ];

  fonts.packages = with pkgs; [ nerdfonts meslo-lgs-nf ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

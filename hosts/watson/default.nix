{ config, lib, pkgs, modulesPath, inputs, host, ... }:
{
  # --- Imports ---
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ./boot.nix
    ./networking.nix
    ./nvidia.nix
    ./impermanence.nix
  ];

  # --- State version ---
  system.stateVersion = host.stateVersion;

  # --- Nixpkgs settings ---
  nixpkgs.config.allowUnfree = true;

  # --- Nix settings ---
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # --- Immutable users ---
  users.mutableUsers = false;

  # --- Disable root login ---
  users.users.root.hashedPassword = "!"; 

  # --- Services ---
  services = {
    blueman.enable = false; # Disable Blueman service
    pulseaudio.enable = false; # Disable pulseaudio
    zfs.autoScrub.enable = true; # Enable automatic scrubbing of ZFS pools
    tailscale.enable = true; # Enable  tailscale
    
    # Enable pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    }; 

    # Enable SSH
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  # --- Localization ---
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # --- Programs ---
  programs = {
    zsh.enable = true;
    firefox.enable = true;
    thunar.enable = true;
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = false;
    };
  };
  
  # --- Security settings ---
  security.pam.services.hyprlock = { }; # For hyprlock to work
  
  # --- Packages ---
  environment.systemPackages = with pkgs; [
    # Shell utilities
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    less
    which
    file
    tree
    diffutils
    man
    pciutils
    unzip

    # Editors
    vim
    neovim
    nano

    # Networking
    curl
    wget
    dnsutils # Provides dig, nslookup
    inetutils # Provides host, etc.
    iproute2
    iputils
    nettools # Provides ifconfig, netstat, etc.
    nmap
    traceroute

    # Monitoring
    htop
    btop
    fastfetch
    strace
    lsof
    tmux
    ripgrep
    fd
    bat
    duf
    ncdu

    # Storage & filesystem tools
    cryptsetup
    rsync
    zfs
    parted
    util-linux # Provides mount, umount, lsblk, blkid, etc.

    # Version control & symlinking
    git
    stow

    # Virtualisation
    libvirt
    virt-manager
    virt-viewer
    qemu

    # Transcoding
    makemkv
    handbrake

    # Hyprland related packages
    kitty
    brightnessctl
    hypridle
    hyprlock
    hyprpaper
    libnotify
    mako
    networkmanagerapplet
    pavucontrol
    waybar
    wlogout
    wofi
  ];
  
  
  # --- Wayland environment settings ---
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # --- Zram settings ---
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };
}

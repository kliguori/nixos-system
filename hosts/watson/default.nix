{ config, lib, pkgs, modulesPath, inputs, host, ... }:

{
  # --- Imports ---
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ./boot.nix
    ./networking.nix
    ./persistence.nix
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

  # --- Immuatable users ---
  users.mutableUsers = false;

  # --- Disable root login ---
  users.users.root.hashedPassword = "!"; 

  # --- SSH ---
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
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
    vim
    neovim
    git
    wget
    curl
    htop

    # Hyprland ecosystem
    brightnessctl
    hypridle
    hyprlock
    hyprpaper
    kitty
    mako
    waybar
    wlogout
    wofi
    
    # Desktop apps
    pavucontrol
    networkmanagerapplet
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

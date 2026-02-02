{ config, lib, pkgs, modulesPath, inputs, hostname, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ./boot.nix
    ../common
  ];

  # State version
  system.stateVersion = "25.11";

  # Nixpkgs settings
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  # Network settings
  networking = { 
    hostName = hostname;
    hostId = "a8c07b12";  # For ZFS - generate with: head -c4 /dev/urandom | od -An -tx1 | tr -d ' \n'
  };

  # Programs  
  programs = {
    thunar.enable = true;
    uwsm.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = false;
    };
  };
  
  # Security settings
  security.pam.services.hyprlock = { }; # For hyprlock to work
  
  # Packages
  environment.systemPackages = with pkgs; [
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
  
  
  # Wayland environment
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Zram settings
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };
}

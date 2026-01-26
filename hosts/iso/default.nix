{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];
  
  # System version
  system.stateVersion = "25.11";

  # ISO label
  isoImage.isoName = "nixos-custom-installer-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";
  
  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";  # For ISO only
      PasswordAuthentication = true;
    };
  };
  
  # Set root password 
  users.users.root.password = "nixos";
  
  # Networking
  networking.networkmanager.enable = true;
  
  # Include useful tools
  environment.systemPackages = with pkgs; [
    # Installation tools
    git
    vim
    neovim
    wget
    curl
    
    # Disk tools
    gparted
    parted
    
    # Network tools
    networkmanager
    
    # ZFS support (for installation)
    zfs
  ];
  
  # Enable ZFS support in live environment
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  
  # Useful for installation
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
}
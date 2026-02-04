{ config, lib, pkgs, ... }:
{
  # Tmpfs root and require /nix and /persist for boot 
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  # Directories and files to persist across boots
  environment.persistence."/persist" = {
    hideMounts = true;
    
    directories = [
      # System state
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      
      # Network
      "/etc/NetworkManager/system-connections"
      
      # Common services
      "/var/lib/tailscale"
    ];
    
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # Required for impermanence
  programs.fuse.userAllowOther = true;
}

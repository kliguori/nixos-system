{ config, lib, pkgs, ... }:

{
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "wheel" "networkmanager" ];
    
    # SSH keys
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... admin@desktop"
    ];

    # Shell
    shell = pkgs.zsh;
  };
}

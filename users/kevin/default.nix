{ config, lib, pkgs, hostname, ... }:

{
  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin Liguori";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPasswordFile = config.age.secrets.kevin-password.path;

    # Define the secret
    age.secrets.kevin-password = {
      file = ../../secrets/kevin-password.age;
      mode = "0400";
      owner = "root";
    };
    
    # SSH keys
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... kevin@desktop"
    ];

    # Shell
    shell = pkgs.zsh;
  };
}

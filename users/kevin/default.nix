{ config, lib, pkgs, hostname, ... }:

{
  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin Liguori";
    extraGroups = [ "wheel" "networkmanager" ];
    password = "nixos";
    # hashedPasswordFile = config.age.secrets.kevin-password.path;

    # Define the secret
    age.secrets.kevin-password = {
      file = ../../secrets/kevin-password.age;
      mode = "0400";
      owner = "root";
    };
    
    # SSH keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOavirFl6Xk3GR2bFfGzX28RYqfwld5lnBdSjTTCAV/0 kevin@macbook"
    ];

    # Shell
    shell = pkgs.zsh;
  };
}

{ config, lib, pkgs, hostname, ... }:

{
  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin Liguori";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$UZmN9CmJmm2mYMVc$Ia3O4psbyXfjM59NEbZY5PBfy.IxIA8yta9F9hYOJ4MVuuFwyrRB1E0uysmG5f8Q1mfZjzlLJ0sES1RQymCUt.";

    # SSH keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOavirFl6Xk3GR2bFfGzX28RYqfwld5lnBdSjTTCAV/0 kevin@macbook"
    ];

    # Shell
    shell = pkgs.zsh;
  };
}

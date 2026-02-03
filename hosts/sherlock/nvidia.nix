{ config, lib, pkgs, ... }:
{
  services.xserver = {
    enable = false; # disable xserver
    videoDrivers = [ "nvidia" ]; # Use nvidia video drivers
  };

  hardware = {
    graphics.enable = true; # Enable graphics hardware
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
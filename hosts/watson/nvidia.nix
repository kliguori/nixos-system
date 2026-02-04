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
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
	  enable = true;
	  enableOffloadCmd = true;
	};
	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}

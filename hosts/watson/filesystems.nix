{ ... }:
{
  fileSystems = {
    "/" = {
      device = "system-pool/root";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/nix" = {
      device = "system-pool/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/persist" = {
      device = "system-pool/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/home" = {
      device = "home-pool/home";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}

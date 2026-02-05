{ ... }:
{
  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/persist" = {
      device = "rpool/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/home" = {
      device = "hpool/home";
      fsType = "zfs";
      neededForBoot = true;
    };
    
    "/srv/media" = {
      device = "dpool/media";
      fsType = "zfs";
      options = [ "nofail" ];
    };

    "/srv/share" = {
      device = "dpool/share";
      fsType = "zfs";
      options = [ "nofail" ];
    };
  
    "/scratch" = {
      device = "spool/scratch";
      fsType = "zfs";
      options = [ "nofail" ];
    };
  };
}

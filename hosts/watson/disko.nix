let
  userDatasets = builtins.listToAttrs (map (user: {
    name = user;
    value = {
      type = "zfs_fs";
      mountpoint = "/home/${user}";
    };
  }) users);
in
{
  disko.devices = {
    
    disk.main = {
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HBJQ-000L7_S4ENNX1R291121";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          
          ESP = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
              extraArgs = [ "-n" "NIXBOOT" ];
            };
          };
          
          zfs = {
            name = "zfs";
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
          
        };
      };
    };
    
    zpool.rpool = {
      type = "zpool";
      
      options = {
        ashift = "12";
        autotrim = "on";
      };
      
      rootFsOptions = {
        mountpoint = "none";
        compression = "zstd";
        atime = "off";
        xattr = "sa";
        acltype = "posixacl";
      };
      
      datasets = {
        
        root = {
          type = "zfs_fs";
          mountpoint = "/";
          postCreateHook = "zfs snapshot rpool/root@blank";
          options = {
            canmount = "noauto";
          };
        };
        
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            atime = "off";
          };
        };
        
        persist = {
          type = "zfs_fs";
          mountpoint = "/persist";
        };
        
      } // userDatasets;
      
    };
    
  };
}
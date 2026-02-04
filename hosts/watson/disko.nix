{
  disk = {
    # System drive
    system = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NG0N214175Z";
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
              mountOptions = [ "fmask=0022" "dmask=0022" ];
              extraArgs = [ "-n" "NIXBOOT" ];
            };
          };
          system-pool = {
            name = "system-pool";
            size = "100%";
            content = { type = "zfs"; pool = "system-pool"; };
          };
        };
      };
    };

    # Home drive 
    home = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M605101P";
      content = {
        type = "gpt";
        partitions = {
          home-pool = {
            name = "home-pool";
            size = "100%";
            content = { type = "zfs"; pool = "home-pool"; };
          };
        };
      };
    };
  };

  zpool = {
    # System pool
    system-pool = {
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
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = { atime = "off"; };
        };
        persist = {
          type = "zfs_fs";
          mountpoint = "/persist";
        };
      };
    };

    # Home pool
    home-pool = {
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
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
        };
      };
    };
  };
}

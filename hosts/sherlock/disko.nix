{
  disk = {
    # System boot drive with rpool
    os = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HBJQ-000L7_S4ENNX1R291121";
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
          rpool = {
            name = "rpool";
            size = "100%";
            content = { type = "zfs"; pool = "rpool"; };
          };
        };
      };
    };

    # Home drive with hpool
    home = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Micron_2300_NVMe_512GB__202829753D71";
      content = {
        type = "gpt";
        partitions = {
          hpool = {
            name = "hpool";
            size = "100%";
            content = { type = "zfs"; pool = "hpool"; };
          };
        };
      };
    };

    # Data storage drive with dpool
    dataShare = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y622750V";
      content = {
        type = "gpt";
        partitions = {
          dpool = {
            name = "dpool";
            size = "100%";
            content = { type = "zfs"; pool = "dpool"; };
          };
        };
      };
    };

    # Hard drive with spool
    hdd1t = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y2YL5RAD";
      content = {
        type = "gpt";
        partitions = {
          spool = {
            name = "spool";
            size = "100%";
            content = { type = "zfs"; pool = "spool"; };
          };
        };
      };
    };
  };

  zpool = {
    # Root pool
    rpool = {
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
          postCreateHook = "zfs snapshot rpool/root@blank";
          options = { 
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
        nix = {
          type = "zfs_fs";
          options = { 
	    atime = "off";
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
        persist = {
          type = "zfs_fs";
          options = { 
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
      };
    };

    # Home pool
    hpool = {
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
          options = { 
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
      };
    };

    # Data pool
    dpool = {
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
        media = {
          type = "zfs_fs";
          options = { 
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
        share = {
          type = "zfs_fs";
          options = { 
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
      };
    };

    # Scratch pool
    spool = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "off";
      };
      rootFsOptions = {
        mountpoint = "none";
        compression = "zstd";
        atime = "off";
        xattr = "sa";
        acltype = "posixacl";
      };
      datasets = {
        scratch = {
          type = "zfs_fs";
          options = { 
	    canmount = "noauto";
	    mountpoint = "legacy";
	  };
        };
      };
    };
  };
}

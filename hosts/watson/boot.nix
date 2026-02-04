{ config, lib, pkgs, ... }:
{
  # --- Boot settings ---
  boot = {
    kernelParams = [
      "zfs.zfs_arc_max=4294967296"  # Limit ZFS ARC to 4GB
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
    zfs = {
      # requestEncryptionCredentials = true; # no zfs encryption right now
      # forceImportAll = true; 
      extraPools = [ 
        "system-pool"
	"home-pool"
      ];
    };
    initrd = {
      # luks.devices.cryptroot.device = "/dev/disk/by-partlabel/disk-main-cryptroot"; # no luks encryption right now
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [
        "nvme"
        "ehci_pci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      
      # Rollback to blank root on boot
      # postDeviceCommands = lib.mkAfter ''
      #   zpool import -N rpool
      #   zfs rollback -r rpool/root@blank
      # '';
    };
  };
}

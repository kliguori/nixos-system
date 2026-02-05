{ config, lib, pkgs, ... }:

{
  # --- Boot settings ---
  boot = {
    kernelParams = [
      "zfs.zfs_arc_max=4294967296"  # Limit ZFS ARC to 4GB
    ];
    kernelModules = [ "sg" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        extraInstallCommands = ''
          chmod 600 $out/loader/random-seed
        '';
      };
    };
    supportedFilesystems = [ "zfs" ];
    zfs = {
      # requestEncryptionCredentials = true; # no zfs encryption right now
      # forceImportAll = true;
      # extraPools = [ 
      #   "rpool"
      #   "hpool"
      #   "dpool"
      #   "spool"
      # ];
    };
    initrd = {
      # luks.devices.cryptroot.device = "/dev/disk/by-partlabel/disk-main-cryptroot"; # no luks encryption right now
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [
        "nvme"
        "ahci"
        "ehci_pci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      
      # Rollback to blank root on boot
      postDeviceCommands = lib.mkAfter ''
        zpool import -N -f rpool hpool dpool spool
        zfs rollback -r rpool/root@blank
      '';
    };
  };
}

{ config, lib, pkgs, modulesPath, ... }:

{ 
  boot = {
    # --- Kernel options ---
    kernelParams = [
      "zfs.zfs_arc_max=4294967296"  # Limit ZFS ARC to 4GB
    ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    
    # --- Bootloader ---
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    # --- ZFS support ---
    supportedFilesystems = [ "zfs" ];
    zfs = {
      # requestEncryptionCredentials = true; # no zfs encryption right now
      extraPools = [ "rpool" ];
    };
    
    # --- Initrd configuration ---
    initrd = {
      supportedFilesystems = [ "zfs" ];
      # luks.devices.cryptroot.device = "/dev/disk/by-partlabel/disk-main-cryptroot"; # no luks encryption right now
      availableKernelModules = [
        "nvme"
        "ehci_pci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      
      # Rollback to blank root on boot
      postDeviceCommands = lib.mkAfter ''
        zpool import -N rpool
        zfs rollback -r rpool/root@blank
      '';
    };
  };
}

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
    supportedFilesystems = [ "btrfs" ];
    initrd = {
      availableKernelModules = [
        "nvme"
        "ehci_pci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };
  };
}

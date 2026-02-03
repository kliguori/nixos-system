{ config, lib, pkgs, host, ... }:

{
  networking = { 
    hostName = host.hostName;
    hostId = host.hostId;  
    useDHCP = lib.mkDefault true; 
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      logRefusedConnections = true;
    };
  };
}
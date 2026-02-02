{ host }:

{
  # Network settings
  networking = { 
    hostName = host.hostName;
    hostId = host.hostId;  
  };
}
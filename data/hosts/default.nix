{
   watson = {
    hostName = "watson";
    hostId = "a8c07b12"; # Generate hostID with: head -c4 /dev/urandom | od -An -tx1 | tr -d ' \n'
    stateVersion = "25.11";
    system = "x86_64-linux";
    sshHostKey = "ssh-ed25519 AAAA... watson";
    users = [
      "kevin"
    ];
  };

  # sherlock = {
  #   hostName = "sherlock";
  #   hostId = "a8c07b12"; # Generate hostID with: head -c4 /dev/urandom | od -An -tx1 | tr -d ' \n'
  #   stateVersion = "25.11";
  #   role = "desktop";
  #   system = "x86_64-linux";
  #   cpu = "amd";
  #   sshHostKey = "ssh-ed25519 AAAA... sherlock";
  #   extraPools = [];
  #   users = [
  #     "kevin"
  #     "alice"
  #   ];
  # };
}
{ inputs }:
{ hosts }:
let
  lib = inputs.nixpkgs.lib;

  # --- mkHost ---
  # Build one nixosConfiguration for a given host
  mkHost = hostKey: host:
  let
    system = host.system;
    hostName = host.hostName or hostKey;
    users = host.users or [];
    hostDir = ../hosts/${hostName};
    diskoFile = hostDir + /disko.nix;
  in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs host;
      };

      modules = [
        # Host modules
        hostDir

        # Disko
        inputs.disko.nixosModules.disko

        # Host-specific Disko layout
        { disko.devices = import diskoFile; }

        # Impermanence
        inputs.impermanence.nixosModules.impermanence

        # Agenix
        inputs.agenix.nixosModules.default

        # Make home-manager package available
        { environment.systemPackages = [ inputs.home-manager.packages.${system}.default ]; }

        # Import user account modules (expects users/<name>/default.nix)
        { imports = map (u: ../users/${u}) users; }
      ];
    };

in lib.mapAttrs mkHost hosts
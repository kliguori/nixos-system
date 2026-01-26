{ inputs }:

{
  # Build nixosSystem and deployNode configurations
  mkSystem = { 
    hostname, 
    system, 
    users ? [], 
    enableDeploy ? true 
  }: 
    let
      myLib = import ./. { inherit inputs; }; # Import my lib
      systemConfig = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit inputs hostname myLib;
          hostUsers = users;
        };
        modules = [
          # Host-specific configuration
          ../hosts/${hostname}
          
          # Disko for declarative disk management
          inputs.disko.nixosModules.disko
          
          # Pass users to disko configuration
          {
            disko.devices = import ../hosts/${hostname}/disko.nix { inherit users; };
          }
          
          # Impermanence module
          inputs.impermanence.nixosModules.impermanence
          
          # Agenix for secrets management
          inputs.agenix.nixosModules.default
          
          # Make home-manager available as a tool for users
          {
            environment.systemPackages = [ 
              inputs.home-manager.packages.${system}.default 
            ];
          }
          
          # Import user account definitions
          { 
            imports = map (user: ../users/${user}) users; 
          }
        ];
      };
    in {
      # NixOS system configuration
      nixosSystem = systemConfig;
      
      # Deploy-rs node configuration
      deployNode = if enableDeploy then {
        hostname = "${hostname}.local";
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.${system}.activate.nixos systemConfig;
        };
      } else null;
    };
}
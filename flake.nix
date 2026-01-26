{
  description = "NixOS System Configurations";

  inputs = {
    # Nix packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Nix hardware helpers
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    
    # Home manager - for user home management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Disko - for declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence - for impermanent root
    impermanence.url = "github:nix-community/impermanence";
    
    # Deploy-RS - to push updates to machines
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Agenix - to manage secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      # Import library functions
      myLib = import ./lib { inherit inputs; };
      
      # Define all systems
      systems = {
        watson = myLib.systems.mkSystem {
          hostname = "watson";
          system = "x86_64-linux";
          users = [ "kevin" ];
          enableDeploy = true;
        };
      };

      # Define live ISOs
      isos = {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/iso ];
        };
      };
    in
    {
      # NixOS Configurations
      nixosConfigurations = 
      (builtins.mapAttrs (_: cfg: cfg.nixosSystem) systems) // isos;
      
      # Deploy-rs Configuration
      deploy = {
        sshUser = "deploy";
        autoRollback = true;
        magicRollback = true;
        
        nodes = builtins.mapAttrs 
          (_: cfg: cfg.deployNode) 
          (nixpkgs.lib.filterAttrs 
            (_: cfg: cfg.deployNode != null) 
            systems
          );
      };
      
      # Check deploy-rs deployments
      checks = builtins.mapAttrs 
        (system: deployLib: deployLib.deployChecks self.deploy) 
        inputs.deploy-rs.lib;
      
      # Development Shell
    };
}
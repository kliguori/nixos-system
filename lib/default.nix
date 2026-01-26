{ inputs }:

{
  # System building functions
  systems = import ./systems.nix { inherit inputs; };
}
{ inputs }:

{
  mkSystems = import ./mkSystems.nix { inherit inputs; };
}
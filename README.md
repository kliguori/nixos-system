# NixOS System Configuration

Disko command

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko \
  --flake github:kliguori/nixos-system#configName

Install command

sudo nixos-install --flake github:kliguori/nixos-system#configName --no-root-password --no-write-lock-file
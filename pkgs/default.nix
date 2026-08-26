{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays { inherit inputs; })
    ./include/memflow
    ./include/kvmfr
    ./system.nix
  ];
}

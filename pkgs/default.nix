args@{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays args)
    ./system.nix
    ./memflow
    ./kvmfr
  ];
}

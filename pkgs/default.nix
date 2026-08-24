args@{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays args)
    ./include/wave3-daemon
    ./include/memflow
    ./include/kvmfr
    ./system.nix
  ];
}

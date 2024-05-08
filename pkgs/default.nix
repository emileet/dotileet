args@{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays.nix args)
    ./system.nix
    ./memflow
    ./kvmfr
  ];
}

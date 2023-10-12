args@{ font-sf-mono, src-kvmfr, src-vban, src-ndi, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays.nix args)
    ./system.nix
    ./memflow
    ./kvmfr
  ];
}

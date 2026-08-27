{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays { inherit inputs; })
    ./include/katana-usb-audio
    ./include/memflow
    ./include/kvmfr
    ./system.nix
  ];
}

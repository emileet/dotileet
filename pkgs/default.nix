{ font-sf-mono, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    (import ./overlays.nix { inherit font-sf-mono; })
    ./system.nix
    ./user.nix
    ./kvmfr
    ./vban
  ];
}

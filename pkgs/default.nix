{ font-sf-mono, ... }:
{
  imports = [
    (import ./overlays.nix { inherit font-sf-mono; })
    ./kvmfr
  ];
}

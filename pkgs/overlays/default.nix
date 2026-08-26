{ inputs, ... }:
let
  inherit (inputs)
    nixpkgs-master
    nvidia-patch
    quickshell
    waybar
    ;
in
{
  nixpkgs.overlays = [
    (import ./include.nix { inherit inputs; })
    (import ./modify.nix { inherit inputs; })
    (import ./secret.nix { inherit inputs; })
    (final: prev: {
      master = import nixpkgs-master {
        system = final.stdenv.hostPlatform.system;
        inherit (final) config;
      };
    })
    nvidia-patch.overlays.default
    quickshell.overlays.default
    waybar.overlays.default
  ];
}

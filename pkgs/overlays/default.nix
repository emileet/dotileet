{ inputs, ... }:
let
  packagesInclude = import ./include.nix { inherit inputs; };
  packagesModify = import ./modify.nix { inherit inputs; };
  packagesSecret = import ./secret.nix { inherit inputs; };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      master = import inputs.nixpkgs-master {
        system = final.stdenv.hostPlatform.system;
        overlays = [ packagesModify ];
        inherit (final) config;
      };
    })
    inputs.nvidia-patch.overlays.default
    inputs.quickshell.overlays.default
    inputs.waybar.overlays.default
    packagesInclude
    packagesModify
    packagesSecret
  ];
}

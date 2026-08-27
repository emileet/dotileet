{ inputs, ... }:
{
  nixpkgs.overlays = [
    (import ./include.nix { inherit inputs; })
    (import ./modify.nix { inherit inputs; })
    (import ./secret.nix { inherit inputs; })
    (final: prev: {
      master = import inputs.nixpkgs-master {
        system = final.stdenv.hostPlatform.system;
        inherit (final) config;
      };
    })
    inputs.nvidia-patch.overlays.default
    inputs.quickshell.overlays.default
    inputs.waybar.overlays.default
  ];
}

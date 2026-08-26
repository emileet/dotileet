args@{
  nixpkgs-master,
  nvidia-patch,
  quickshell,
  waybar,
  font-sf-mono,
  src-vkcapture,
  src-distroav,
  src-kvmfr,
  src-vban,
  src-ndi,
  ...
}:
{
  nixpkgs.overlays = [
    (import ./include.nix font-sf-mono src-vban src-vkcapture src-distroav)
    (import ./modify.nix src-kvmfr src-ndi)
    (import ./secret.nix args)
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

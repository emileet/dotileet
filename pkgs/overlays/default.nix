{
  nixpkgs-master,
  nixpkgs-stable,
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
    (final: prev: {
      master = import nixpkgs-master {
        stdenv.hostPlatform.system = final.system;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        stdenv.hostPlatform.system = final.system;
        config.allowUnfree = true;
      };
    })
  ];
}

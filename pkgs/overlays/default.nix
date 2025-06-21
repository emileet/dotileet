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
        config.allowUnfree = true;
        system = final.system;
      };
      stable = import nixpkgs-stable {
        config.allowUnfree = true;
        system = final.system;
      };
    })
  ];
}

{
  nixpkgs-master,
  nixpkgs-stable,
  font-sf-mono,
  src-vkcapture,
  src-kvmfr,
  src-vban,
  ...
}:
{
  nixpkgs.overlays = [
    (import ./include.nix font-sf-mono src-vban src-vkcapture)
    (import ./modify.nix src-kvmfr)
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

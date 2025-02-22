{
  nixpkgs-master,
  font-sf-mono,
  src-vkcapture,
  src-kvmfr,
  src-vban,
  ...
}:
{
  nixpkgs.overlays = [
    (import ./include.nix src-vban src-vkcapture)
    (import ./modify.nix font-sf-mono src-kvmfr)
    (final: prev: {
      master = import nixpkgs-master {
        config.allowUnfree = true;
        system = final.system;
      };
    })
  ];
}

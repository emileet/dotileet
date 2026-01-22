{
  nixpkgs,
  nixpkgs-master,
  nixpkgs-stable,
  nix-index-database,
  home-manager,
  impermanence,
  font-sf-mono,
  src-vkcapture,
  src-distroav,
  src-kvmfr,
  src-vban,
  src-ndi,
  ...
}:
let
  pkgs = (
    import ../pkgs {
      inherit
        nixpkgs-master
        nixpkgs-stable
        font-sf-mono
        src-vkcapture
        src-distroav
        src-kvmfr
        src-vban
        src-ndi
        ;
    }
  );

  home = {
    home-manager.users.emileet = import ../home;
    home-manager.useGlobalPkgs = true;
  };

  sharedModules = (import ../modules) ++ [
    nix-index-database.nixosModules.nix-index
    impermanence.nixosModules.impermanence
    home-manager.nixosModules.home-manager
    home
    pkgs
  ];

  lib = nixpkgs.lib;
in
{
  nix = lib.nixosSystem {
    modules = sharedModules ++ [ ./nix ];
  };
  shodan = lib.nixosSystem {
    modules = sharedModules ++ [ ./shodan ];
  };
}

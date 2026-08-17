{
  nixpkgs,
  nixpkgs-master,
  nix-index-database,
  home-manager,
  impermanence,
  nvidia-patch,
  silent-sddm,
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
        nvidia-patch
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
    silent-sddm.nixosModules.default
    home
    pkgs
  ];

  lib = nixpkgs.lib;
in
{
  nix = lib.nixosSystem {
    modules = sharedModules ++ [ ./nix ];
  };
  nixsrv = lib.nixosSystem {
    modules = sharedModules ++ [ ./nixsrv ];
  };
  shodan = lib.nixosSystem {
    modules = sharedModules ++ [ ./shodan ];
  };
}

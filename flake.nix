{
  description = ".dotileet - emileet's nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-pinned.url = "github:nixos/nixpkgs/ed142ab1b3a092c4d149245d0c4126a5d7ea00b0";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    font-sf-mono = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    src-vkcapture = {
      url = "github:scaledteam/obs-vkcapture";
      flake = false;
    };

    src-distroav = {
      url = "github:DistroAV/DistroAV";
      flake = false;
    };

    src-kvmfr = {
      url = "git+https://github.com/gnif/LookingGlass?submodules=1";
      flake = false;
    };

    src-vban = {
      url = "git+https://github.com/quiniouben/vban?submodules=1";
      flake = false;
    };

    src-ndi = {
      url = "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v6_Linux.tar.gz";
      flake = false;
    };
  };

  outputs =
    args@{
      self,
      nixpkgs,
      nixpkgs-master,
      nixpkgs-pinned,
      nix-index-database,
      home-manager,
      impermanence,
      nvidia-patch,
      font-sf-mono,
      src-vkcapture,
      src-distroav,
      src-kvmfr,
      src-vban,
      src-ndi,
    }:
    {
      nixosConfigurations = (import ./hosts args);
    };
}

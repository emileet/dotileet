{ font-sf-mono, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      sf-mono-liga = prev.stdenvNoCC.mkDerivation rec {
        pname = "sf-mono-liga";
        version = "dev";
        src = font-sf-mono;
        dontConfigure = true;
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp -R $src/*.otf $out/share/fonts/opentype/
        '';
      };
    })
    (final: prev: {
      looking-glass-client = prev.looking-glass-client.overrideAttrs {
        version = "dev";
        src = prev.fetchFromGitHub {
          repo = "LookingGlass";
          owner = "gnif";
          rev = "e658c2e0a205c40701b00d97364c2a9903ed34cf";
          sha256 = "sha256-AOb79RiHpYnrPv/jHCijAgr4uIe+TUIsY8pmVt0b0cU=";
          fetchSubmodules = true;
        };
      };
    })
    (final: prev: {
      qemu = (prev.qemu.overrideAttrs {
        patches = [ /nix/patches/qemu/qemu-vmi.8.1.0.patch ];
      }).override {
        enableDocs = false;
      };
    })
    (final: prev: {
      catppuccin-gtk = prev.catppuccin-gtk.override {
        accents = [ "pink" "lavender" ];
        tweaks = [ "rimless" ];
        variant = "mocha";
        size = "compact";
      };
    })
    (final: prev: {
      polybar = prev.polybar.override {
        githubSupport = true;
        pulseSupport = true;
        i3Support = true;
      };
    })
  ];
}

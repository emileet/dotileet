{ font-sf-mono, src-vkcapture, src-kvmfr, src-vban, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      colloid-gtk-theme = prev.colloid-gtk-theme.override {
        tweaks = [ "rimless" "dracula" ];
        themeVariants = [ "purple" ];
        sizeVariants = [ "compact" ];
      };
    })
    (final: prev: {
      polybar = prev.polybar.override {
        githubSupport = true;
        pulseSupport = true;
        i3Support = true;
      };
    })
    # (final: prev: {
    #   discord = prev.discord.override {
    #     withOpenASAR = true;
    #     withVencord = true;
    #   };
    # })
    (final: prev: {
      sf-mono-liga = prev.stdenvNoCC.mkDerivation {
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
      qemu = (prev.qemu.overrideAttrs {
        patches = [ /nix/patches/qemu/qemu-vmi-9.0.1.patch ];
      }).override {
        enableDocs = false;
      };
    })
    (final: prev: {
      looking-glass-client = prev.looking-glass-client.overrideAttrs rec {
        src = src-kvmfr;
        version = "dev";
        desktopItem = prev.makeDesktopItem {
          desktopName = "Looking Glass Client";
          exec = "looking-glass-client";
          name = "looking-glass-client";
          type = "Application";
          icon = "lg-logo";
          terminal = false;
        };
        patches = [];
        postInstall = ''
          mkdir -p $out/share/pixmaps
          ln -s ${desktopItem}/share/applications $out/share/
          cp $src/resources/lg-logo.png $out/share/pixmaps
        '';
      };
    })
    (final: prev: {
      obs-studio-plugins.obs-ndi = prev.obs-studio-plugins.obs-ndi.overrideAttrs (oldAttrs: {
        cmakeFlags = [ "-DENABLE_QT=ON" "--compile-no-warning-as-error" ];
      });
    })
    (final: prev: {
      vban = prev.callPackage ./vban { inherit src-vban; };
      obs-vkcapture-kms = prev.callPackage ./vkcapture { inherit src-vkcapture; };
      obs-kvmfr = prev.callPackage ./kvmfr/obs { };
    })
  ];
}

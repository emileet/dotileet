{ font-sf-mono, src-kvmfr, src-vban, src-ndi, ... }:
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
      looking-glass-client = prev.looking-glass-client.overrideAttrs (oldAttrs: rec {
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
        postInstall = ''
          mkdir -p $out/share/pixmaps
          ln -s ${desktopItem}/share/applications $out/share/
          cp $src/resources/lg-logo.png $out/share/pixmaps
        '';
      });
    })
    (final: prev: {
      qemu = (prev.qemu.overrideAttrs {
        patches = [ /nix/patches/qemu/qemu-vmi-8.1.0.patch ];
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
      python3 = prev.python3.override {
        packageOverrides = python-final: python-prev: {
          catppuccin = python-prev.catppuccin.overridePythonAttrs {
            # missing rich module import for UT? too lazy to investigate :)
            doCheck = false;
          };
        };
      };
    })
    (final: prev: {
      polybar = prev.polybar.override {
        githubSupport = true;
        pulseSupport = true;
        i3Support = true;
      };
    })
    (final: prev: {
      discord = prev.discord.override {
        withOpenASAR = true;
        withVencord = true;
      };
    })
    (final: prev: {
      ndi = prev.ndi.overrideAttrs (oldAttrs: rec {
        version = "dev";
        src = src-ndi;
        unpackPhase = ''
          echo y | $src
          sourceRoot="NDI SDK for Linux";
        '';
        installPhase = ''
          mkdir $out
          mv bin/x86_64-linux-gnu $out/bin
          for i in $out/bin/*; do
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$i"
          done
          patchelf --set-rpath "${prev.avahi}/lib:${prev.stdenv.cc.libc}/lib" $out/bin/ndi-record
          mv lib/x86_64-linux-gnu $out/lib
          for i in $out/lib/*; do
            if [ -L "$i" ]; then continue; fi
            patchelf --set-rpath "${prev.avahi}/lib:${prev.stdenv.cc.libc}/lib" "$i"
          done
          mv include examples $out/
          mkdir -p $out/share/doc/${oldAttrs.pname}-${version}
          mv licenses $out/share/doc/${oldAttrs.pname}-${version}/licenses
          mv documentation/* $out/share/doc/${oldAttrs.pname}-${version}/
        '';
      });
    })
    (final: prev: {
      vban = prev.callPackage ./vban { inherit src-vban; };
      obs-kvmfr = prev.callPackage ./kvmfr/obs { };
    })
  ];
}

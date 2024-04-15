{ font-sf-mono, src-vkcapture, src-kvmfr, src-vban, src-ndi, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      catppuccin-gtk = prev.catppuccin-gtk.override {
        accents = [ "pink" "lavender" ];
        tweaks = [ "rimless" ];
        variant = "mocha";
        size = "compact";
      };
    })
    # (final: prev: {
    #   xivlauncher = prev.xivlauncher.overrideAttrs {
    #     postPatch = ''
    #       sed -i '73,80d' lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Dalamud/DalamudLauncher.cs
    #       substituteInPlace lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Game/Patch/Acquisition/Aria/AriaHttpPatchAcquisition.cs \
    #         --replace 'ariaPath = "aria2c"' 'ariaPath = "${prev.aria2}/bin/aria2c"'
    #       substituteInPlace lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Dalamud/DalamudLauncher.cs \
    #         --replace 'https://kamori.goats.dev/Dalamud/Release/VersionInfo?track=' 'https://emi.gay/xiv/dalamud/'
    #       substituteInPlace lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Dalamud/DalamudUpdater.cs \
    #         --replace 'release&bucket={this.RolloutBucket}' 'release'
    #     '';
    #   };
    # })
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
        patches = [ /nix/patches/qemu/qemu-vmi-8.1.0.patch ];
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
            if [ -L "$i" ]; then rm $i && continue; fi
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
      obs-vkcapture-kms = prev.callPackage ./vkcapture { inherit src-vkcapture; };
      obs-kvmfr = prev.callPackage ./kvmfr/obs { };
    })
  ];
}

src-kvmfr: src-ndi:
(final: prev: {
  polybar = prev.polybar.override {
    githubSupport = true;
    pulseSupport = true;
    i3Support = true;
  };
  colloid-gtk-theme = prev.colloid-gtk-theme.override {
    tweaks = [
      "rimless"
      "dracula"
    ];
    themeVariants = [ "purple" ];
    sizeVariants = [ "compact" ];
  };
  looking-glass-client = prev.looking-glass-client.overrideAttrs (oldAttrs: {
    src = src-kvmfr;
    version = "dev";
    patches = [ /nix/patches/looking-glass/nanosvg-unvendor.patch ];
    buildInputs = oldAttrs.buildInputs ++ [
      prev.libunwind
      prev.elfutils
      prev.fuse3
    ];
  });
  ndi = prev.ndi.overrideAttrs (oldAttrs: rec {
    version = "dev";
    src = src-ndi;
    unpackPhase = ''
      echo y | $src/Install_NDI_SDK_v6_Linux.sh
      sourceRoot="NDI SDK for Linux";
    '';
    installPhase = ''
      mkdir $out
      mv bin/x86_64-linux-gnu $out/bin
      rm $out/bin/libndi.so.*
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

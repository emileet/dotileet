font-sf-mono: src-kvmfr:
(final: prev: {
  polybar = prev.polybar.override {
    githubSupport = true;
    pulseSupport = true;
    i3Support = true;
  };
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
  colloid-gtk-theme = prev.colloid-gtk-theme.override {
    tweaks = [ "rimless" "dracula" ];
    themeVariants = [ "purple" ];
    sizeVariants = [ "compact" ];
  };
  qemu = (prev.qemu.overrideAttrs {
    patches = [ /nix/patches/qemu/qemu-vmi-9.0.1.patch ];
  }).override {
    enableDocs = false;
  };
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
    postPatch = ''
      sed -i '1656s/float t\[6\];/float t[6] = {0};/' ../repos/nanosvg/src/nanosvg.h
    '';
    postInstall = ''
      mkdir -p $out/share/pixmaps
      ln -s ${desktopItem}/share/applications $out/share/
      cp $src/resources/lg-logo.png $out/share/pixmaps
    '';
  };
  obs-studio-plugins.obs-ndi = prev.obs-studio-plugins.obs-ndi.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [ "--compile-no-warning-as-error" ];
  });
})

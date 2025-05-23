src-kvmfr:
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
  qemu =
    (prev.qemu.overrideAttrs {
      patches = [ /nix/patches/qemu/qemu-vmi-9.0.1.patch ];
    }).override
      {
        enableDocs = false;
      };
  looking-glass-client = prev.looking-glass-client.overrideAttrs {
    src = src-kvmfr;
    version = "dev";
  };
})

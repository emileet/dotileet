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
  spicetify-cli = prev.spicetify-cli.overrideAttrs rec {
    version = "2.39.5";
    src = prev.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "v${version}";
      hash = "sha256-vqif3oLDm9SUrkY+qEYHUEmHN+psoK6GNUB+kA6sQ4Q=";
    };
    ldflags = [
      "-s -w"
      "-X 'main.version=${version}'"
    ];
    postInstall = ''
      mv $out/bin/cli $out/bin/spicetify
      ln -s $out/bin/spicetify $out/bin/spicetify-cli
      cp -r ${src}/jsHelper $out/bin/jsHelper
      cp -r ${src}/CustomApps $out/bin/CustomApps
      cp -r ${src}/Extensions $out/bin/Extensions
      cp -r ${src}/Themes $out/bin/Themes
    '';
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
    patches = [ ];
    env.NIX_CFLAGS_COMPILE = "-Wno-maybe-uninitialized";
    postInstall = ''
      mkdir -p $out/share/pixmaps
      ln -s ${desktopItem}/share/applications $out/share/
      cp $src/resources/lg-logo.png $out/share/pixmaps
    '';
  };
})

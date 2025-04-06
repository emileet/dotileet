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
    version = "2.39.6";
    src = prev.fetchFromGitHub {
      owner = "spicetify";
      repo = "cli";
      rev = "v${version}";
      hash = "sha256-rdyHVHKVgl9fOviFYQuXY8Ko+/XwpKlKDfriQAgkusE=";
    };
    vendorHash = "sha256-sC8HmszcH5fYnuoPW6aElB8UXPwk3Lpp2odsBaiP4mI=";
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
  looking-glass-client = prev.looking-glass-client.overrideAttrs {
    src = src-kvmfr;
    version = "dev";
  };
})

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
  xow_dongle-firmware = prev.xow_dongle-firmware.overrideAttrs (old: {
    version = "0-unstable-2025-12-18";
    srcs = [
      (prev.fetchurl {
        url = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2017/03/2ea9591b-f751-442c-80ce-8f4692cdc67b_6b555a3a288153cf04aec6e03cba360afe2fce34.cab";
        hash = "sha256-2Jpy6NwQt8TxbVyIf+f1TDTCIAWsHzYHBNXZRiJY7zI=";
      })
      (prev.fetchurl {
        url = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab";
        hash = "sha256-ZXNqhP9ANmRbj47GAr7ZGrY1MBnJyzIz3sq5/uwPbwQ=";
      })
      (prev.fetchurl {
        url = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/06/1dbd7cb4-53bc-4857-a5b0-5955c8acaf71_9081931e7d664429a93ffda0db41b7545b7ac257.cab";
        hash = "sha256-kN2R+2dGDTh0B/2BCcDn0PGPS2Wb4PYtuFihhJ6tLuA=";
      })
      (prev.fetchurl {
        url = "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2017/08/aeff215c-3bc4-4d36-a3ea-e14bfa8fa9d2_e58550c4f74a27e51e5cb6868b10ff633fa77164.cab";
        hash = "sha256-Wo+62VIeWMxpeoc0cgykl2cwmAItYdkaiL5DMALM2PI=";
      })
    ];
    unpackPhase = ''
      srcs=($srcs)

      cabextract -F FW_ACC_00U.bin ''${srcs[0]}
      mv FW_ACC_00U.bin xone_dongle_02e6.bin

      cabextract -F FW_ACC_00U.bin ''${srcs[1]}
      mv FW_ACC_00U.bin xone_dongle_02fe.bin

      cabextract -F FW_ACC_CL.bin ''${srcs[2]}
      mv FW_ACC_CL.bin xone_dongle_02f9.bin

      cabextract -F FW_ACC_BR.bin ''${srcs[3]}
      mv FW_ACC_BR.bin xone_dongle_091e.bin
    '';
    installPhase = ''
      mkdir -p $out/lib/firmware/
      cp xone_dongle_*.bin $out/lib/firmware/
    '';
  });
})

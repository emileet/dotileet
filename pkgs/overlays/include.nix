src-vban: src-vkcapture:
(final: prev: {
  vban = prev.callPackage ../include/vban { inherit src-vban; };
  obs-vkcapture-kms = prev.callPackage ../include/vkcapture { inherit src-vkcapture; };
  obs-kvmfr = prev.callPackage ../include/kvmfr/obs { };
})

src-vban: src-vkcapture:
(final: prev: {
  vban = prev.callPackage ../vban { inherit src-vban; };
  obs-vkcapture-kms = prev.callPackage ../vkcapture { inherit src-vkcapture; };
  obs-kvmfr = prev.callPackage ../kvmfr/obs { };
})
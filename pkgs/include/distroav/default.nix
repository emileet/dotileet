{
  lib,
  stdenv,
  obs-studio,
  cmake,
  qt6,
  ndi,
  curl,
  src-distroav,
}:

stdenv.mkDerivation {
  pname = "obs-distroav";
  version = "6.1.1";

  nativeBuildInputs = [
    qt6.qtbase
    cmake
  ];
  buildInputs = [
    obs-studio
    ndi
    curl
  ];

  src = src-distroav;

  patches = [
    ./hardcode-ndi-path.patch
  ];

  postPatch = ''
    # Add path (variable added in hardcode-ndi-path.patch
    sed -i -e s,@NDI@,${ndi},g src/plugin-main.cpp

    # Replace bundled NDI SDK with the upstream version
    # (This fixes soname issues)
    rm -rf lib/ndi
    ln -s ${ndi}/include lib/ndi
  '';

  cmakeFlags = [ "-DENABLE_QT=ON" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Network A/V plugin for OBS Studio";
    homepage = "https://github.com/DistroAV/DistroAV";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      jshcmpbll
      emileet
    ];
    platforms = platforms.linux;
    hydraPlatforms = ndi.meta.hydraPlatforms;
  };
}

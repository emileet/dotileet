{
  lib,
  stdenv,
  pkg-config,
  cmake,
  obs-studio,
  libdrm,
  libGL,
  vulkan-headers,
  vulkan-loader,
  src-vkcapture,
  ...
}:
stdenv.mkDerivation rec {
  pname = "obs-vkcapture-kms";
  version = "dev";

  src = src-vkcapture;
  patches = [ ./vkle-drm.patch ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    obs-studio
    libdrm.dev
    libGL
  ];

  DRM_INCLUDE_DIR = "${libdrm.dev}/include/libdrm";
  cmakeFlags = [ "-DDRM_INCLUDE_DIR=${DRM_INCLUDE_DIR}" ];

  meta = with lib; {
    description = "VKCapture with KMSGrab included";
    homepage = "https://github.com/scaledteam/obs-vkcapture";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

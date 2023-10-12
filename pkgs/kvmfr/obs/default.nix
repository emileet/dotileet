{ lib, stdenv, obs-studio, cmake, libbfd, libGL, looking-glass-client, ... }:

stdenv.mkDerivation rec {
  pname = "obs-kvmfr";
  version = looking-glass-client.version;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio libbfd libGL ];

  cmakeFlags = [ "-DOPTIMIZE_FOR_NATIVE=OFF" ];

  src = looking-glass-client.src;
  sourceRoot = "source/obs";

  installPhase = ''
    mkdir -p $out/lib/obs-plugins
    install -D liblooking-glass-obs.so $out/lib/obs-plugins/liblooking-glass-obs.so
  '';

  meta = with lib; {
    description = "An extremely low latency KVMFR (KVM FrameRelay) implementation for guests with VGA PCI Passthrough in OBS Studio.";
    homepage = "https://github.com/gnif/LookingGlass";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

{
  stdenv,
  kernel,
  lib,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "katana-usb-audio-${version}-${kernel.version}";
  version = "dev";

  src = fetchFromGitHub {
    owner = "mrworf";
    repo = "katana-usb-audio";
    rev = "master";
    sha256 = "sha256-cmjPyFaEBDn8x7LlKInDaUY6nim3lw1Zm0cqU5V5rnU=";
  };

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D ./katana_usb_audio.ko -t $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = with lib; {
    description = "Linux kernel module for the SoundBlaster X Katana USB Audio Device";
    homepage = "https://github.com/mrworf/katana-usb-audio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

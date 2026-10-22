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

  makeFlags = kernel.commonMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=extra"
  ];

  buildFlags = [ "modules" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel module for the SoundBlaster X Katana USB Audio Device";
    homepage = "https://github.com/mrworf/katana-usb-audio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

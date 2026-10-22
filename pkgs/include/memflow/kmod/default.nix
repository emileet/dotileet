{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  ...
}:
stdenv.mkDerivation rec {
  pname = "memflow-${version}-${kernel.version}";
  version = "dev";

  src = fetchFromGitHub {
    owner = "memflow";
    repo = "memflow-kvm";
    rev = "refs/tags/bin-v0.2.1";
    sha256 = "sha256-7qGM8pxjfGpxZM8HT5rtLDo3c95CjiMSBR9pi4WvKew=";
    fetchSubmodules = true;
  };

  patches = [ /nix/patches/memflow/memflow-kmod.patch ];

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.commonMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/memflow-kmod"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=extra"
  ];

  buildFlags = [ "modules" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel module for memflow's KVM connector";
    homepage = "https://github.com/memflow/memflow-kvm";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

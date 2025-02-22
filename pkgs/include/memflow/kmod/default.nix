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

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KBUILD_OUTPUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D ./memflow-kmod/memflow.ko -t $out/lib/modules/${kernel.modDirVersion}/misc/
  '';

  meta = with lib; {
    description = "Linux kernel module for memflow's KVM connector";
    homepage = "https://github.com/memflow/memflow-kvm";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

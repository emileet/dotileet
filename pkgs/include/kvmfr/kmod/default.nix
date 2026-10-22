{
  stdenv,
  lib,
  kernel,
  looking-glass-client,
  ...
}:
stdenv.mkDerivation rec {
  pname = "kvmfr-${version}-${kernel.version}";
  version = looking-glass-client.version;

  src = looking-glass-client.src;
  sourceRoot = "source/module";
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
    description = "This kernel module implements a basic interface to the IVSHMEM device for LookingGlass";
    homepage = "https://github.com/gnif/LookingGlass";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ j-brn ];
    platforms = [ "x86_64-linux" ];
  };
}

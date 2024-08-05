{ stdenv, lib, fetchFromGitHub, kernel, ... }:
stdenv.mkDerivation rec {
  pname = "memflow-${version}-${kernel.version}";
  version = "dev";

  src = fetchFromGitHub {
    owner = "memflow";
    repo = "memflow-kvm";
    rev = "refs/tags/bin-main";
    sha256 = "sha256-KCPHd50qltFXDRE2J5rbWiX7wwFGtbJk3sNXYmaXzJc=";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D ./build/memflow.ko -t $out/lib/modules/${kernel.modDirVersion}/misc/
  '';

  meta = with lib; {
    description = "Linux kernel module for memflow's KVM connector";
    homepage = "https://github.com/memflow/memflow-kvm";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

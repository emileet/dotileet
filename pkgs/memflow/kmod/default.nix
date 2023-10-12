{ stdenv, lib, fetchFromGitHub, kernel, ... }:
stdenv.mkDerivation rec {
  pname = "memflow-${version}-${kernel.version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "memflow";
    repo = "memflow-kvm";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IVpK2Y6k9tr4SvCtupOpAvdaMtjz3CAYgh50UWQuEFk=";
    fetchSubmodules = true;
  };

  patches = [
    /nix/patches/memflow/memflow-kmod-0.1.7.patch
  ];

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    sed -e "s@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@" -i Makefile
  '';

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

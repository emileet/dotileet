{ stdenv, lib, fetchFromGitHub, pkg-config, autoconf, automake, alsaLib, libpulseaudio, libjack2, ... }:
stdenv.mkDerivation rec {
  pname = "vban";
  version = "dev";

  src = fetchFromGitHub {
    repo = "vban";
    owner = "quiniouben";
    rev = "4f69e5a6cd02627a891f2b15c2cf01bf4c87d23d";
    sha256 = "sha256-V7f+jcj3NpxXNr15Ozx2is4ReeeVpl3xvelMuPNfNT0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config autoconf automake alsaLib.dev libpulseaudio libjack2 ];

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';

  meta = with lib; {
    description = "VBAN protocol open-source implementation";
    homepage = "https://github.com/quiniouben/vban";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
  };
}

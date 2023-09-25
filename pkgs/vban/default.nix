{ stdenv, lib, fetchFromGitHub, pkg-config, autoconf, automake, alsaLib, libpulseaudio, libjack2, src-vban, ... }:
stdenv.mkDerivation rec {
  pname = "vban";
  version = "dev";
  src = src-vban;

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

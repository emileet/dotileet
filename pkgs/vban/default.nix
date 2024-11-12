{ stdenv, lib, pkg-config, autoconf, automake, alsa-lib, libpulseaudio, libjack2, src-vban, ... }:
stdenv.mkDerivation {
  pname = "vban";
  version = "dev";
  src = src-vban;

  nativeBuildInputs = [ pkg-config autoconf automake alsa-lib.dev libpulseaudio libjack2 ];

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

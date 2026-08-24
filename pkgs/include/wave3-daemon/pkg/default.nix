{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  libusb1,
  gtk4,
  glib,
  pipewire,
  wireplumber,
  python3Packages,
  ...
}:
stdenv.mkDerivation {
  pname = "wave3-daemon";
  version = "dev";

  src = fetchFromGitHub {
    owner = "LukasParke";
    repo = "wave3-research";
    rev = "master";
    hash = "sha256-KL7EhEVUPN8CY/lYGFx7ZyTd/6IrLlqkI9jH802l1iE=";
  };

  sourceRoot = "source/native-linux/src";

  nativeBuildInputs = [
    python3Packages.dbus-python
    makeBinaryWrapper
    pkg-config
    wireplumber
    pipewire
    libusb1
    gtk4
  ];

  buildInputs = [
    glib
  ];

  installPhase = ''
    install -Dm755 wave3-daemon $out/bin/wave3-daemon
    install -Dm755 ../bin/wave3ctl $out/bin/wave3ctl
    wrapProgram $out/bin/wave3ctl --prefix PATH : ${lib.makeBinPath [ glib ]}
  '';

  meta = with lib; {
    description = "Userspace D-Bus daemon for the Elgato Wave:3 microphone";
    homepage = "https://github.com/LukasParke/wave3-research";
    maintainers = with maintainers; [ emileet ];
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Only;
  };
}

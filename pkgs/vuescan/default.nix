{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeDesktopItem,
  gtk3,
  libpulseaudio,
  libxkbcommon,
  libgudev,
  libusb1,
  glib,
}:

let
  desktopItem = makeDesktopItem {
    name = "vuescan";
    exec = "vuescan";
    icon = "vuescan";
    desktopName = "VueScan";
    genericName = "Scanner interface utility";
    categories = [
      "Graphics"
      "Scanning"
    ];
    startupWMClass = "Vuescan";
  };
in

stdenv.mkDerivation rec {
  pname = "vuescan";
  version = "9.8.53";

  src =
    let
      srcs = {
        x86_64-linux = {
          url = "https://files.hamrick.com/vuex6498.tgz";
          sha256 = "0bf9qgxrd63c1qr1wqvxj2mkv8n11b8m51wrippznh7cgpazhxy7";
        };
        aarch64-linux = {
          url = "https://files.hamrick.com/vuea6498.tgz";
          sha256 = "0rgrrf9llw63yr0296m529dqx6wflhj19a2lqwcc4hb06hajpxjg";
        };
      };
    in
    fetchurl srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gtk3
    libpulseaudio
    libxkbcommon
    libgudev
    libusb1
    glib
    stdenv.cc.cc.lib
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 vuescan $out/bin/vuescan
    install -Dm644 vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg
    install -Dm644 vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules
    ln -s ${desktopItem}/share/applications $out/share/applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Scanning software supporting over 6000 scanners from 42 manufacturers";
    homepage = "https://www.hamrick.com/";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "vuescan";
  };
}

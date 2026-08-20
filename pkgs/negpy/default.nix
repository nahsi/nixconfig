{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "negpy";
  version = "0.52.0";

  src = fetchurl {
    url = "https://github.com/marcinz606/NegPy/releases/download/${version}/NegPy-${version}-x86_64.AppImage";
    hash = "sha256-nDqxvyQB5U4EJjn9STXn+qvn19cdwW503VpUaeN8Vt8=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/negpy.desktop $out/share/applications/negpy.desktop
    install -Dm444 ${appimageContents}/icon.png $out/share/icons/hicolor/512x512/apps/negpy.png

    substituteInPlace $out/share/applications/negpy.desktop \
      --replace-fail "Exec=NegPy" "Exec=negpy" \
      --replace-fail "Icon=icon" "Icon=negpy"
  '';

  meta = {
    description = "Tool for processing film negatives";
    homepage = "https://github.com/marcinz606/NegPy";
    downloadPage = "https://github.com/marcinz606/NegPy/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "negpy";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

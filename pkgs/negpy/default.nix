{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "negpy";
  version = "0.45.0";

  src = fetchurl {
    url = "https://github.com/marcinz606/NegPy/releases/download/${version}/NegPy-${version}-x86_64.AppImage";
    hash = "sha256-XXD7M1IqQU6N7fk7da+VG+AHjWbyUfJRkps7a3SUHtU=";
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

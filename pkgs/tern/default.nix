{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  desktop-file-utils,
  git,
  glib,
  gtk3,
  xdg-utils,
  vulkan-loader,
  libGL,
  libxkbcommon,
  libxcb,
  wayland,
  libpulseaudio,
  pam,
}:

let
  build = "20261102-152242-2ad447b";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tern";
  version = "0.9.10";

  src = requireFile {
    name = "Tern-${finalAttrs.version}-linux-x86_64.tar.gz";
    url = "https://build.stencil.so/d/tern/${build}/Tern-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-W9eCMo3w7iMw809gxAei8CUrrG6AbmINIrdEvOrUxtU=";
  };

  sourceRoot = "tern";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ stdenv.cc.cc.lib ];
  dontAutoPatchelf = true;

  appendRunpaths = [
    (lib.makeLibraryPath [
      vulkan-loader
      libGL
      libxkbcommon
      libxcb
      wayland
      libpulseaudio
      pam
    ])
    "/run/opengl-driver/lib"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 tern $out/bin/.tern-wrapped
    makeWrapper $out/bin/.tern-wrapped $out/bin/tern \
      --prefix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
          git
          glib
          gtk3
          xdg-utils
        ]
      }
    runHook postInstall
  '';

  postFixup = ''
    autoPatchelf $out
    export HOME=$TMPDIR XDG_DATA_HOME=$TMPDIR/share
    $out/bin/tern register >/dev/null
    for entry in so.stencil.tern so.stencil.tern.url; do
      install -Dm644 $XDG_DATA_HOME/applications/$entry.desktop $out/share/applications/$entry.desktop
      substituteInPlace $out/share/applications/$entry.desktop \
        --replace-fail '"'$out/bin/.tern-wrapped'"' $out/bin/tern
    done
    for icon in $XDG_DATA_HOME/icons/hicolor/*/apps/so.stencil.tern.png; do
      install -Dm644 $icon $out/share/icons/hicolor/''${icon#$XDG_DATA_HOME/icons/hicolor/}
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Rust-native terminal workspace from Stencil";
    homepage = "https://stencil.so/tern";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "tern";
    platforms = [ "x86_64-linux" ];
  };
})

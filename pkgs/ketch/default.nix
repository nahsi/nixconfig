{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ketch";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/1broseidon/ketch/releases/download/v${finalAttrs.version}/ketch_${finalAttrs.version}_linux_x86_64.tar.gz";
    hash = "sha256-gHf59qE0fMKYDUASkjwLQdbrW1LwI80UYC94wKvWGK4=";
  };

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ketch $out/bin/ketch

    runHook postInstall
  '';

  meta = {
    description = "Stateless CLI for web search, code search, documentation, and scraping";
    homepage = "https://github.com/1broseidon/ketch";
    license = lib.licenses.mit;
    mainProgram = "ketch";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

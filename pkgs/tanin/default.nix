{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  alsa-lib,
  libopus,
  openssl,
  yt-dlp,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tanin";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "AnonMiraj";
    repo = "Tanin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gzWUFVofuZ2Q48jsMouBcjHDcbqju+nJYtAiMe7iovA=";
  };

  cargoHash = "sha256-WbIo5NsOF2eJcPB28C1ZMq8KsCCC9bexdiAoGkJV/BE=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libopus
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/tanin \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
  '';

  meta = {
    description = "TUI ambient noise mixer";
    homepage = "https://github.com/AnonMiraj/Tanin";
    license = lib.licenses.mit;
    mainProgram = "tanin";
    platforms = lib.platforms.linux;
  };
})

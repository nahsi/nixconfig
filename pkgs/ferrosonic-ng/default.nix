{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  makeWrapper,
  mpv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ferrosonic";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Jamie098";
    repo = "ferrosonic-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3M7Pskgutm9tbcTONvQ44rpuBD/MlAivZRBRMxq0BKg=";
  };

  cargoHash = "sha256-KN+Lg+N/XOvAg3+TTeoJLW/y0rgY0ji6ubTzoU6oLdI=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/ferrosonic \
      --prefix PATH : ${lib.makeBinPath [ mpv ]}
  '';

  meta = {
    description = "Terminal-based Subsonic music client with bit-perfect audio playback";
    homepage = "https://github.com/Jamie098/ferrosonic-ng";
    license = lib.licenses.mit;
    mainProgram = "ferrosonic";
  };
})

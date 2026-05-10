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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Jamie098";
    repo = "ferrosonic-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AmSZkxQ12SFo8hHfHi7eXr+LF6Z8TCajA1hr9S+ivjk=";
  };

  cargoHash = "sha256-NhB6ztyveC73oCwYRCfuuvazl3gYavB7igrRBrhRi9c=";

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

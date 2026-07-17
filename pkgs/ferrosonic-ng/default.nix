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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Jamie098";
    repo = "ferrosonic-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ReKJxGusk106WF+spXeXgTAdIvnYMsLRcx55X1Lch3w=";
  };

  cargoHash = "sha256-aav2CRG4CCnGHEW7Ole1tttWV02ENBIDKOm5qHfnBMc=";

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

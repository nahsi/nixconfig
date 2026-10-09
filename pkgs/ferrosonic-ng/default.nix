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
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Jamie098";
    repo = "ferrosonic-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7BXegC4nUVNM44t7Rzkuh5Efh1u2eznwjv9FqAi6nzE=";
  };

  cargoHash = "sha256-znpZy9i5gNYMom2jnbDr7J7slkBITTIt8rpzVMxdluM=";

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

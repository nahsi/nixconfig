{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  webkitgtk_4_1,
}:

buildGoModule rec {
  pname = "wayfinder-maps";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rengwu";
    repo = "wayfinder-maps";
    tag = "v${version}";
    hash = "sha256-mk9jklDdU/CaxeDRB61q78yPWZrKFu9M7GNd7SxsSeo=";
  };

  vendorHash = "sha256-+Dwep/nVPn/OOi/d94ACpnBIvt3JMFbm0JDp57YOvgI=";

  subPackages = [
    "cmd/wayfinder-maps"
    "cmd/wayfinder-maps-webview"
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];

  postInstall = ''
    install -Dm755 scripts/wayfinder-app "$out/bin/wayfinder-app"
    install -Dm755 scripts/wayfinder-web "$out/bin/wayfinder-web"
  '';

  meta = {
    description = "Read-only CLI and viewer for Wayfinder planning maps";
    homepage = "https://github.com/rengwu/wayfinder-maps";
    license = lib.licenses.mit;
    mainProgram = "wayfinder-maps";
    platforms = lib.platforms.linux;
  };
}

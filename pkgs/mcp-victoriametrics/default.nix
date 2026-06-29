{
  lib,
  buildGo126Module,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "mcp-victoriametrics";
    tag = "v${version}";
    hash = "sha256-7kN7qwsvTL0scfBxMO/nrvikiysUxPY8nSFkhJsgGDM=";
  };

  web = buildNpmPackage {
    pname = "mcp-victoriametrics-web";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-Q6Ljqtbwz0pEvUcz8keps8Nr8xzOUusW0zBZq1mkz/Q=";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };
in
buildGo126Module {
  pname = "mcp-victoriametrics";
  inherit version src;

  vendorHash = null;

  preBuild = ''
    cp -r ${web} web/dist/
  '';

  ldflags = [
    "-X main.version=v${version}"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  subPackages = [ "cmd/mcp-victoriametrics" ];

  meta = {
    description = "Model Context Protocol (MCP) server for VictoriaMetrics";
    homepage = "https://github.com/VictoriaMetrics/mcp-victoriametrics";
    license = lib.licenses.asl20;
    mainProgram = "mcp-victoriametrics";
  };
}

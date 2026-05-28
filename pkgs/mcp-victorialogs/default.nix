{
  lib,
  buildGo126Module,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "mcp-victorialogs";
    tag = "v${version}";
    hash = "sha256-esfd6Eg1j2BCgee1T5tiIdSPWVEBqhI4UGDKRFYyn3s=";
  };

  web = buildNpmPackage {
    pname = "mcp-victorialogs-web";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-B8kEHH7vv1Mp1gLwsFLaFkUyNZsq2ZZHH9U6+a7JlOA=";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };
in
buildGo126Module {
  pname = "mcp-victorialogs";
  inherit version src;

  vendorHash = null;

  preBuild = ''
    cp -r ${web} web/dist/
  '';

  ldflags = [
    "-X main.version=v${version}"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  subPackages = [ "cmd/mcp-victorialogs" ];

  meta = {
    description = "Model Context Protocol (MCP) server for VictoriaLogs";
    homepage = "https://github.com/VictoriaMetrics/mcp-victorialogs";
    license = lib.licenses.asl20;
    mainProgram = "mcp-victorialogs";
  };
}

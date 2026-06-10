{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

let
  version = "0.0.62";
in
buildGo126Module {
  pname = "kubernetes-mcp-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "kubernetes-mcp-server";
    tag = "v${version}";
    hash = "sha256-m4oM8KMcDmXwIGaFw+VdnW22kLjt2SaD7qZV4kgTiu8=";
  };

  vendorHash = "sha256-JNeYn/IfzQ2VLDbHgrkserh3wrXYOWXBczBn2DUO6NM=";

  subPackages = [ "cmd/kubernetes-mcp-server" ];

  # Example_version asserts the default unset version (0.0.0); we inject one via ldflags.
  checkFlags = [ "-skip=Example_version" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/containers/kubernetes-mcp-server/pkg/version.Version=v${version}"
    "-X github.com/containers/kubernetes-mcp-server/pkg/version.BinaryName=kubernetes-mcp-server"
  ];

  meta = {
    description = "Model Context Protocol (MCP) server for Kubernetes and OpenShift";
    homepage = "https://github.com/containers/kubernetes-mcp-server";
    license = lib.licenses.asl20;
    mainProgram = "kubernetes-mcp-server";
  };
}

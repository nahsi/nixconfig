{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy
    gcc
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };
}

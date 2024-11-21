{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };
}

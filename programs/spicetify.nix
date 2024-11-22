{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;
    spicetifyPackage = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.spicetify-cli;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}

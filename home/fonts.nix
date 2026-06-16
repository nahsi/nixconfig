{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    fira-code
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    roboto
    roboto-slab
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Fira Code"
        "FiraCode Nerd Font"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "Fira Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "Roboto Slab"
        "Noto Serif CJK JP"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}

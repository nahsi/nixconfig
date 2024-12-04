{ pkgs, config, ... }:
let
  # NNN colours - catppuccin
  # https://github.com/catppuccin/catppuccin/discussions/1955#discussion-4904597
  BLK = "03";
  CHR = "03";
  DIR = "04";
  EXE = "02";
  REG = "07";
  HARDLINK = "05";
  SYMLINK = "05";
  MISSING = "08";
  ORPHAN = "01";
  FIFO = "06";
  SOCK = "03";
  UNKNOWN = "01";
in
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    extraPackages = with pkgs; [
      # nuke dependencies
      atool # file archives
      rar
      zip
      p7zip
      zathura
      mpv
      glow
      jq
      w3m
      imv

      # preview-tui dependencies
      bat
      eza
      ffmpeg
      fzf
      gnutar
      imagemagick
      mediainfo
      mktemp
      poppler_utils
      unzip
    ];
    plugins = {
      src = null;
      mappings = {
        c = "cdpath";
        p = "preview-tui";
        v = "imgview";
      };
    };
  };

  xdg.configFile."nnn/plugins" = {
    source = "${pkgs.nnn}/share/plugins";
    recursive = true;
  };

  home.sessionVariables = {
    # https://github.com/catppuccin/catppuccin/discussions/1955#discussion-4904597
    NNN_COLORS = "#04020301;4231";
    NNN_FCOLORS = "${BLK}${CHR}${DIR}${EXE}${REG}${HARDLINK}${SYMLINK}${MISSING}${ORPHAN}${FIFO}${SOCK}${UNKNOWN}";
    NNN_ICONLOOKUP = "0";
    NNN_FIFO = "/tmp/nnn.fifo";
    NNN_PREVIEWDIR = "${config.xdg.cacheHome}/nnn/previews";
    NNN_OPENER = "${pkgs.nnn}/share/plugins/nuke";
    NNN_SPLIT = "v";
    GUI = "1";
  };
}

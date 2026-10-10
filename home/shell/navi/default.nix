{ config, lib, ... }:
{
  programs.navi = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    settings.cheats.paths = [
      "${config.xdg.configHome}/navi/cheats"
      "${config.xdg.dataHome}/navi/cheats"
    ];
  };

  programs.zsh.initContent = lib.mkOrder 1100 ''
    bindkey -M viins '^G' _navi_widget
    bindkey -M vicmd '^G' _navi_widget
  '';

  xdg.configFile."navi/cheats".source = ./cheats;
}

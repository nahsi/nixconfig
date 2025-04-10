{ hostConfig, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      font_size = hostConfig.fontSize;
      font_family = "Fira Code";
      font_features = "Fira Code Regular +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +ss08 +zero +onum";

      enable_audio_bell = "no";
    };
    extraConfig = ''
      allow_remote_control yes
    '';
  };
}

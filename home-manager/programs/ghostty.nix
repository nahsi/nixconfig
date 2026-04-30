{ hostConfig, ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      font-family = "Fira Code";
      font-size = hostConfig.fontSize;
      shell-integration-features = "ssh-env,ssh-terminfo";
      quit-after-last-window-closed = "true";
      quit-after-last-window-closed-delay = "5m";
    };
    systemd.enable = true;
  };
}

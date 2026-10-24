{ inputs, system, ... }:
{
  services.sendspin = {
    enable = true;
    package = inputs.self.packages.${system}.sendspin;
    extraArgs = [
      "--name"
      "Framework"
      "--audio-device"
      "pipewire"
      "--hardware-volume"
      "false"
      "--url"
      "wss://ha.nahsi.dev/sendspin"
    ];
  };
}

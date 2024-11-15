{ config, ... }:

{
  networking.wireguard.interfaces = {
    relay = {
      ips = [ "10.0.100.2/24" ];
      privateKeyFile = "${config.users.users.nahsi.home}/.local/wireguard/private";
      peers = [
        {
          publicKey = "RSQSt5Tk/CG+hXF03gMighDQVNX6pPRih4nZnPcptDY=";
          allowedIPs = [
            "10.0.100.10/32"
            "10.1.10.0/24"
          ];
          endpoint = "91.245.37.33:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

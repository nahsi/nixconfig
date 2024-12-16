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

  networking.wg-quick.interfaces = {
    hcloud = {
      address = [ "10.8.1.5/32" ];
      privateKeyFile = "${config.users.users.nahsi.home}/.local/wireguard/hcloud/private";

      peers = [
        {
          publicKey = "6A2BA+ZUHEtobjYrYNN4/Q88aXxHsE+j9A3bXxBc5gg=";
          presharedKeyFile = "${config.users.users.nahsi.home}/.local/wireguard/hcloud/preshared_key";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          persistentKeepalive = 25;
          endpoint = "37.27.194.213:41617";
        }
      ];
    };
  };
}

{ config, pkgs, ... }:

let
  tunName = "singbox-home";
in
{
  systemd.services.sing-box.wantedBy = pkgs.lib.mkForce [ ];
  services.sing-box = {
    enable = true;
    package = pkgs.sing-box;

    settings = {
      log = {
        level = "info";
      };

      inbounds = [
        {
          type = "tun";
          tag = "tun-in";
          interface_name = tunName;
          address = [ "172.19.0.1/30" ];
          auto_route = true;
          strict_route = true;
          mtu = 1500;
        }
      ];

      outbounds = [
        {
          type = "vless";
          tag = "proxy";
          server = "vpn.nahsi.dev";
          server_port = 443;
          uuid = {
            _secret = config.age.secrets.singbox.path;
          };

          tls = {
            utls = {
              enabled = true;
              fingerprint = "chrome";
            };

            enabled = true;
            server_name = "www.cloudflare.com";
            reality = {
              enabled = true;
              public_key = "p2EBmySx4-2SDiCzg825nUNo85lMx_UmE7tn7vNjAHQ";
              short_id = "4157611183c3588f";
            };
          };
        }

        {
          type = "direct";
          tag = "direct";
        }
      ];

      route = {
        auto_detect_interface = true;
        final = "proxy";
      };
    };
  };

  networking.firewall.trustedInterfaces = [ tunName ];
}

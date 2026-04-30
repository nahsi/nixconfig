{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  server = "mail.nahsi.dev";

  mkAccount =
    {
      address,
      realName,
      secret,
      extraIdentities ? [ ],
    }:
    {
      root_mailbox = "INBOX";
      format = "imap";
      identity = address;
      display_name = realName;
      subscribed_mailboxes = [
        "Inbox"
        "Sent"
        "Drafts"
        "Trash"
        "Junk"
      ];
      server_hostname = server;
      server_port = 993;
      server_username = address;
      server_password_command = "cat ${osConfig.age.secrets.${secret}.path}";
      send_mail = {
        hostname = server;
        port = 465;
        auth = {
          type = "auto";
          username = address;
          password = {
            type = "command_eval";
            value = "cat ${osConfig.age.secrets.${secret}.path}";
          };
        };
        security = {
          type = "tls";
          danger_accept_invalid_certs = false;
        };
      };
    }
    // lib.optionalAttrs (extraIdentities != [ ]) {
      extra_identities = extraIdentities;
    };
in
{
  xdg.configFile."meli/themes/catppuccin-mocha.toml".source = ./catppuccin-mocha.toml;

  home.packages = [ pkgs.w3m ];

  programs.meli = {
    enable = true;
    settings = {
      terminal.theme = "catppuccin-mocha";
      accounts = {
        personal = mkAccount {
          address = "nahsi@nahsi.dev";
          realName = "nahsi"; # replace
          secret = "meli-personal-password";
          extraIdentities = [
            "nahsi <nahsi@nahsi.dev>"
            "Anatolios Laskaris <nahsi@nahsi.dev>"
          ];
        };
        trash = mkAccount {
          address = "trash@nahsi.dev";
          realName = "nahsi";
          secret = "meli-trash-password";
        };
      };
    };
  };
}

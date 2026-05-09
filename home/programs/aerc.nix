{
  osConfig,
  ...
}:
{
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
      };
      filters = {
        "text/plain" = "wrap -w 80 | colorize";
        "text/html" = "html | colorize";
        "text/calendar" = "calendar";
        "text/x-diff" = "hldiff";
        "text/x-patch" = "hldiff";
      };
      openers = {
        "image/*" = "nsxiv {}";
        "application/pdf" = "zathura {}";
        "x-scheme-handler/http" = "qutebrowser {}";
        "x-scheme-handler/https" = "qutebrowser {}";
      };
    };
    extraAccounts = ''
      [personal]
      from = nahsi <nahsi@nahsi.dev>
      aliases = Anatolios Laskaris <nahsi@nahsi.dev>
      source = jmap://nahsi%40nahsi.dev@mail.nahsi.dev/.well-known/jmap
      source-cred-cmd = cat ${osConfig.age.secrets.mail-personal-password.path}
      outgoing = jmap://
      default = Inbox
      copy-to = Sent
      postpone = Drafts
      check-mail = 2m

      [trash]
      from = nahsi <trash@nahsi.dev>
      source = jmap://trash%40nahsi.dev@mail.nahsi.dev/.well-known/jmap
      source-cred-cmd = cat ${osConfig.age.secrets.mail-trash-password.path}
      outgoing = jmap://
      default = Inbox
      copy-to = Sent
      check-mail = 5m
    '';
  };
}

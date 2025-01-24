{
  hostConfig,
  config,
  pkgs,
  ...
}:
let
  qutebrowser-setup = pkgs.writeShellScript "qutebrowser-setup" (
    builtins.concatStringsSep "\n" (
      builtins.map (
        n: "${config.programs.qutebrowser.package}/share/qutebrowser/scripts/dictcli.py install ${n}"
      ) config.programs.qutebrowser.settings.spellcheck.languages
    )
  );
in
{

  systemd.user.services.qutebrowser-setup = {
    Unit = {
      Description = "Fetch qutebrowser dicts for my languages";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = qutebrowser-setup;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      "yt" = "https://www.youtube.com/results?search_query={}";
      "gg" = "http://www.google.com/search?hl=en&q={}";
      "gh" = "https://github.com/search?q={}&type=Code";
      "ghn" = "https://github.com/search?q=language%3Anix {}&type=Code";
      "mn" = "https://mynixos.com/search?q={}";
    };
    settings = {
      zoom.default = "${hostConfig.qutebrowserZoom}";
      fonts.default_size = "12pt";
      colors.webpage.preferred_color_scheme = "dark";
      colors.webpage.bg = "white";
      url.start_pages = [ "https://home.nahsi.dev" ];
      url.default_page = "https://home.nahsi.dev";
      spellcheck.languages = [
        "en-US"
        "ru-RU"
      ];
      content = {
        autoplay = false;
        geolocation = false;
        notifications = {
          enabled = false;
        };
        cookies.accept = "no-3rdparty";
        javascript = {
          clipboard = "access";
        };
        tls = {
          certificate_errors = "ask-block-thirdparty";
        };
        # don't register handlers for things like mail and calendar
        register_protocol_handler = false;
      };
    };
    extraConfig = ''
      import os
      from urllib.request import urlopen

      # load your autoconfig, use this, if the rest of your config is empty!
      config.load_autoconfig()

      if not os.path.exists(config.configdir / "theme.py"):
        theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
        with urlopen(theme) as themehtml:
          with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

      if os.path.exists(config.configdir / "theme.py"):
        import theme
        theme.setup(c, 'mocha', True)

      c.colors.webpage.bg = "white"

      c.bindings.key_mappings = {
      'Й': 'Q', 'й': 'q',
      'Ц': 'W', 'ц': 'w',
      'У': 'E', 'у': 'e',
      'К': 'R', 'к': 'r',
      'Е': 'T', 'е': 't',
      'Н': 'Y', 'н': 'y',
      'Г': 'U', 'г': 'u',
      'Ш': 'I', 'ш': 'i',
      'Щ': 'O', 'щ': 'o',
      'З': 'P', 'з': 'p',
      'Х': '{', 'х': '[',
      'Ъ': '}', 'ъ': ']',
      'Ф': 'A', 'ф': 'a',
      'Ы': 'S', 'ы': 's',
      'В': 'D', 'в': 'd',
      'А': 'F', 'а': 'f',
      'П': 'G', 'п': 'g',
      'Р': 'H', 'р': 'h',
      'О': 'J', 'о': 'j',
      'Л': 'K', 'л': 'k',
      'Д': 'L', 'д': 'l',
      'Ж': ':', 'ж': ';',
      'Э': '"', 'э': "'",
      'Я': 'Z', 'я': 'z',
      'Ч': 'X', 'ч': 'x',
      'С': 'C', 'с': 'c',
      'М': 'V', 'м': 'v',
      'И': 'B', 'и': 'b',
      'Т': 'N', 'т': 'n',
      'Ь': 'M', 'ь': 'm',
      'Б': '<', 'б': ',',
      'Ю': '>', 'ю': '.',
      ',': '?', '.': '/',
      }
    '';
  };
}

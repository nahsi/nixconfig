{
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

  xdg.mimeApps.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };

  xdg.configFile."qutebrowser/userstyles/searxng.css".source = ./userstyles/searxng.css;

  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      "DEFAULT" = "https://search.nahsi.dev/search?q={}";
      "ddg" = "https://duckduckgo.com/?q={}";
      "yt" = "https://yt.nahsi.dev/search/{}";
      "gg" = "http://www.google.com/search?hl=en&q={}";
      "gh" = "https://github.com/search?q={}&type=Code";
      "ghn" = "https://github.com/search?q=language%3Anix {}&type=Code";
      "ghy" = "https://github.com/search?q=language%3Ayaml {}&type=Code";
      "mn" = "https://mynixos.com/search?q={}";
    };
    settings = {
      zoom.default = "125%";
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

      # QtWebEngine 6.11.x flickers web video on AMD+Wayland via its GBM path;
      # qutebrowser's built-in workaround only triggers on exactly 6.11.0.
      c.qt.environ = {"QTWEBENGINE_FORCE_USE_GBM": "0"}

      if not os.path.exists(config.configdir / "theme.py"):
        theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
        with urlopen(theme) as themehtml:
          with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

      if os.path.exists(config.configdir / "theme.py"):
        import theme
        theme.setup(c, 'mocha', True)

      c.colors.webpage.bg = "white"

      with config.pattern('https://search.nahsi.dev/*'):
        config.set('content.user_stylesheets', ['~/.config/qutebrowser/userstyles/searxng.css'])

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

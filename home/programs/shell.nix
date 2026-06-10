{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    jq
    yq-go
    fd
    file
    dust
    duf
    procs
    tlrc
    hyperfine
    sd
    ast-grep
    viddy
    fastfetch
    just
    pwgen
    mkpasswd
    openssl
    skopeo

    atool
    p7zip
    zip
    unzip
    unrar

    poppler-utils
    imagemagick
    glow
  ];

  programs = {
    bash.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      defaultKeymap = "viins";
      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        size = 10000;
        save = 0;
        share = false;
      };

      setOptions = [
        "EXTENDED_GLOB"
        "AUTO_PUSHD"
        "PUSHD_IGNORE_DUPS"
        "PUSHD_SILENT"
        "INTERACTIVE_COMMENTS"
        "NO_BEEP"
      ];

      syntaxHighlighting.enable = true;

      zsh-abbr = {
        enable = true;
        abbreviations = {
          k = "kubectl";
          tf = "terraform";
          gco = "git checkout";
          gcm = "git commit -m";
          gst = "git status";
          gp = "git push";
          gl = "git pull";
        };
      };

      initContent = lib.mkMerge [
        (lib.mkOrder 600 ''
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        '')
        (lib.mkOrder 800 ''
          ZVM_INIT_MODE=sourcing
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        '')
        ''
          zstyle ':completion:*' menu no
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
          zstyle ':completion:*:descriptions' format '[%d]'
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          zstyle ':fzf-tab:*' query-string '''
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          zstyle ':fzf-tab:*' switch-group '<' '>'
          zstyle ':fzf-tab:*' fzf-min-height 15
          zstyle ':fzf-tab:*' fzf-flags --preview-window=right:55%:wrap
        ''
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      fileWidgetCommand = "fd --type f --hidden --exclude .git";
      changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
      defaultOptions = [
        "--reverse"
        "--border"
      ];
      fileWidgetOptions = [ "--height=40%" ];
      changeDirWidgetOptions = [ "--height=40%" ];
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
    };

    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;
    starship.enable = true;
    bat.enable = true;

    btop = {
      enable = true;
      settings.show_coretemp = false;
    };

    eza = {
      enable = true;
      git = true;
    };

    k9s.enable = true;
    yazi.enable = true;

    nh = {
      enable = true;
      flake = "/home/nahsi/nixfiles";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      daemon.enable = true;
      flags = [ "--disable-ai" ];
      settings = {
        auto_sync = false;
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "global";
        keymap_mode = "vim-insert";
        enter_accept = true;
        inline_height = 25;
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = false;
    };
    nix-index-database.comma.enable = true;
  };

  services.pueue.enable = true;
}

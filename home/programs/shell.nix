{ pkgs, ... }:
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

    # archive
    atool
    p7zip
    zip
    unzip
    unrar

    # preview
    poppler-utils
    imagemagick
    glow
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;

      # atuin honors ignorespace too; leading-space commands stay off the record
      historyControl = [ "ignorespace" ];

      shellAliases = {
        l = "eza";
        ll = "eza -l --git";
        la = "eza -lah --git";
        lt = "eza --tree --git-ignore";
        llt = "eza -lT --git --git-ignore";
      };

      initExtra = ''
        # Refuse to clobber existing files on >; use >| to force
        set -o noclobber

        shopt -s checkwinsize histappend cmdhist
        shopt -s globstar nocaseglob
        shopt -s autocd cdspell dirspell

        bind Space:magic-space
        bind "set completion-ignore-case on"
        bind "set completion-map-case on"
        bind "set show-all-if-ambiguous on"
        bind "set mark-symlinked-directories on"

        set bell-style none
      '';
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    ripgrep.enable = true;
    starship.enable = true;
    bat.enable = true;

    btop = {
      enable = true;
      settings = {
        show_coretemp = false;
      };
    };
    eza.enable = true;
    k9s.enable = true;
    yazi.enable = true;

    nh = {
      enable = true;
      flake = "/home/nahsi/nixfiles";
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };

  services.pueue.enable = true;
}

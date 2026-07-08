{
  inputs,
  system,
  ...
}:
let
  tomatPkg = inputs.nixpkgs-unstable.legacyPackages.${system}.tomat;
in
{
  services.tomat = {
    enable = true;
    package = tomatPkg;

    settings = {
      timer = {
        work = 50;
        break = 10;
        long_break = 20;
        sessions = 4;
        auto_advance = "none";
      };

      notification.enabled = true;

      sound = {
        mode = "embedded";
        volume = 0.1;
      };

      display.text_format = "{time}";
    };
  };

  programs.zsh.zsh-abbr.abbreviations = {
    pd = "tomat start -w 90 -b 20 -l 30 -s 2";
    pf = "tomat start";
    pq = "tomat start -w 25 -b 5";
    ps = "tomat stop";
    pk = "tomat skip";
  };
}

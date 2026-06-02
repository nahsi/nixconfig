{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  palette =
    (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
    .${config.catppuccin.flavor}.colors;
  c = name: lib.substring 1 6 palette.${name}.hex;
  accent = c config.catppuccin.accent;
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };

  # cap'd binary exposed under a separate name so the wrapper below can own 'trip'
  security.wrappers.trip-cap = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_raw+p";
    source = "${pkgs.trippy}/bin/trip";
  };

  # 'trip' in PATH = shell wrapper that always passes our themed config
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "trip" ''
      exec /run/wrappers/bin/trip-cap -c /etc/trippy.toml "$@"
    '')
  ];

  environment.etc."trippy.toml".text = ''
    [theme-colors]
    bg-color = "${c "base"}"
    border-color = "${c "surface2"}"
    text-color = "${c "text"}"
    tab-text-color = "${accent}"
    hops-table-header-bg-color = "${c "surface0"}"
    hops-table-header-text-color = "${accent}"
    hops-table-row-active-text-color = "${c "text"}"
    hops-table-row-inactive-text-color = "${c "subtext0"}"
    hops-chart-selected-color = "${accent}"
    hops-chart-unselected-color = "${c "overlay0"}"
    hops-chart-axis-color = "${c "surface2"}"
    frequency-chart-bar-color = "${c "green"}"
    frequency-chart-text-color = "${c "subtext1"}"
    flows-chart-bar-selected-color = "${accent}"
    flows-chart-bar-unselected-color = "${c "overlay0"}"
    flows-chart-text-current-color = "${c "text"}"
    flows-chart-text-non-current-color = "${c "subtext0"}"
    samples-chart-color = "${c "peach"}"
    samples-chart-lost-color = "${c "red"}"
    help-dialog-bg-color = "${c "mantle"}"
    help-dialog-text-color = "${c "text"}"
    settings-dialog-bg-color = "${c "mantle"}"
    settings-tab-text-color = "${accent}"
    settings-table-header-bg-color = "${c "surface0"}"
    settings-table-header-text-color = "${accent}"
    settings-table-row-text-color = "${c "text"}"
    map-world-color = "${c "surface2"}"
    map-radius-color = "${c "yellow"}"
    map-selected-color = "${c "green"}"
    map-info-panel-border-color = "${c "surface2"}"
    map-info-panel-bg-color = "${c "mantle"}"
    map-info-panel-text-color = "${c "text"}"
    info-bar-bg-color = "${c "surface0"}"
    info-bar-text-color = "${c "text"}"
  '';
}

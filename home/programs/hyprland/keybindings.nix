{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;

  bind = key: action: {
    _args = [
      key
      action
    ];
  };
  bindOpts = key: action: opts: {
    _args = [
      key
      action
      opts
    ];
  };

  modKey = combo: mkLuaInline ''mod .. " + ${combo}"'';
  secondModKey = combo: mkLuaInline ''secondMod .. " + ${combo}"'';

  exec = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';

  workspaceKeys = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
  ];
in
{
  wayland.windowManager.hyprland.settings.bind = [
    # Standard keybindings
    (bind (modKey "RETURN") (exec "ghostty +new-window"))
    (bind (modKey "Q") (exec "qutebrowser"))
    (bind (modKey "C") (mkLuaInline "hl.dsp.window.close()"))
    (bind (modKey "SHIFT + M") (mkLuaInline "hl.dsp.exit()"))
    (bind (modKey "E") (exec "dolphin"))
    (bind (modKey "V") (mkLuaInline ''hl.dsp.window.float({ action = "toggle" })''))
    (bind (modKey "R") (exec "fuzzel"))
    (bind (modKey "P") (mkLuaInline "hl.dsp.window.pseudo()"))
    (bind (modKey "T") (mkLuaInline ''hl.dsp.layout("togglesplit")''))
    (bind "CTRL + ALT + L" (exec "hyprlock"))

    # Focus movement (hjkl)
    (bind (modKey "H") (mkLuaInline ''hl.dsp.focus({ direction = "left" })''))
    (bind (modKey "J") (mkLuaInline ''hl.dsp.focus({ direction = "down" })''))
    (bind (modKey "K") (mkLuaInline ''hl.dsp.focus({ direction = "up" })''))
    (bind (modKey "L") (mkLuaInline ''hl.dsp.focus({ direction = "right" })''))

    # Move window in tile direction (Super+Shift+hjkl)
    (bind (modKey "SHIFT + H") (mkLuaInline ''hl.dsp.window.swap({ direction = "left" })''))
    (bind (modKey "SHIFT + J") (mkLuaInline ''hl.dsp.window.swap({ direction = "down" })''))
    (bind (modKey "SHIFT + K") (mkLuaInline ''hl.dsp.window.swap({ direction = "up" })''))
    (bind (modKey "SHIFT + L") (mkLuaInline ''hl.dsp.window.swap({ direction = "right" })''))

    # Cycle windows
    (bind (secondModKey "J") (mkLuaInline "hl.dsp.window.cycle_next()"))
    (bind (secondModKey "SHIFT + J") (mkLuaInline "hl.dsp.window.cycle_next({ prev = true })"))

    # Special workspaces
    (bind (modKey "S") (mkLuaInline ''hl.dsp.workspace.toggle_special("scratch")''))
    (bind (modKey "SHIFT + S") (mkLuaInline ''hl.dsp.window.move({ workspace = "special:scratch" })''))
    (bind (modKey "F") (mkLuaInline ''hl.dsp.workspace.toggle_special("music")''))

    # Mouse wheel workspace switching
    (bind (modKey "mouse_down") (mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })''))
    (bind (modKey "mouse_up") (mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })''))

    # Screenshots
    (bind (modKey "PRINT") (exec "hyprshot -m output --clipboard-only"))
    (bind (secondModKey "SHIFT + P") (exec "hyprshot -m output --clipboard-only"))
    (bind "PRINT" (exec "hyprshot -m region --clipboard-only"))
    (bind (secondModKey "P") (exec "hyprshot -m region --clipboard-only"))
  ]
  # Workspace bindings 1-9
  ++ (builtins.map (
    k: bind (modKey k) (mkLuaInline "hl.dsp.focus({ workspace = ${k} })")
  ) workspaceKeys)
  ++ [ (bind (modKey "0") (mkLuaInline "hl.dsp.focus({ workspace = 10 })")) ]
  # Move to workspace 1-9
  ++ (builtins.map (
    k: bind (modKey "SHIFT + ${k}") (mkLuaInline ''hl.dsp.window.move({ workspace = "${k}" })'')
  ) workspaceKeys)
  ++ [ (bind (modKey "SHIFT + 0") (mkLuaInline ''hl.dsp.window.move({ workspace = "10" })'')) ]
  ++ [
    # Mouse drag/resize
    (bindOpts (modKey "mouse:272") (mkLuaInline "hl.dsp.window.drag()") { mouse = true; })
    (bindOpts (modKey "mouse:273") (mkLuaInline "hl.dsp.window.resize()") { mouse = true; })

    # Volume keys (locked + repeating)
    (bindOpts "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
      locked = true;
      repeating = true;
    })

    # Brightness keys (locked + repeating)
    (bindOpts "XF86MonBrightnessUp" (exec "brightnessctl s 10%+") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86MonBrightnessDown" (exec "brightnessctl s 10%-") {
      locked = true;
      repeating = true;
    })
    (bindOpts "SHIFT + XF86MonBrightnessUp" (exec "ddcutil --display 1 setvcp 10 + 5") {
      locked = true;
      repeating = true;
    })
    (bindOpts "SHIFT + XF86MonBrightnessDown" (exec "ddcutil --display 1 setvcp 10 - 5") {
      locked = true;
      repeating = true;
    })

    # Player controls (locked)
    (bindOpts "XF86AudioNext" (exec "playerctl -p ferrosonic next") { locked = true; })
    (bindOpts "XF86AudioPause" (exec "playerctl -p ferrosonic play-pause") { locked = true; })
    (bindOpts "XF86AudioPlay" (exec "playerctl -p ferrosonic play-pause") { locked = true; })
    (bindOpts "XF86AudioPrev" (exec "playerctl -p ferrosonic previous") { locked = true; })

    # Lid switch: close = disable eDP-1, open = re-enable
    (bindOpts "switch:on:Lid Switch"
      (mkLuaInline ''function() hl.monitor({output="eDP-1", disabled=true}) end'')
      { locked = true; }
    )
    (bindOpts "switch:off:Lid Switch"
      (mkLuaInline ''function() hl.monitor({output="eDP-1", mode="preferred", position="0x0", scale=1.6, disabled=false}) end'')
      { locked = true; }
    )
  ];
}

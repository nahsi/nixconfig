{
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprlandPlugins,
  hyprland,
  qt6,
  kdePackages,
  nlohmann_json,
  ffmpeg,
  glib,
  lua,
  libdrm,
  wl-clipboard,
  gpu-screen-recorder,
}:

hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hyprcapture";
  version = "0.2.1-unstable-2026-05-17";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "HyprCapture";
    rev = "36f1a6e2f14ca863fe861aacb2f807a7b8a29dfc";
    hash = "sha256-Jvjm/LFLt5ODuGNTHK6FvP32VQIzkQTyRibFNjnmy0s=";
  };

  env.NIX_CFLAGS_COMPILE = "-isystem ${lib.getDev libdrm}/include/libdrm";

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kdePackages.layer-shell-qt
    nlohmann_json
    ffmpeg
    glib
    lua
    libdrm
  ];

  postInstall = ''
    qtWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        wl-clipboard
        gpu-screen-recorder
      ]
    })
  '';

  meta = {
    description = "Screenshot and screen recording tool for Hyprland";
    homepage = "https://github.com/gfhdhytghd/HyprCapture";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}

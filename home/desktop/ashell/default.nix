{
  inputs,
  system,
  pkgs,
  ...
}:
let
  tomat = inputs.nixpkgs-unstable.legacyPackages.${system}.tomat;

  # TODO: ashell stubs "(pot tooltip)" and "appearance etc" on CustomModuleDef.
  # If upstream lands tooltip/class support, drop this transform and pass through
  # tomat's native tooltip + percentage for a full waybar-style pill.
  pomodoro-pill = pkgs.writeShellApplication {
    name = "pomodoro-pill";
    runtimeInputs = [
      tomat
      pkgs.taskwarrior3
      pkgs.python3
    ];
    text = "exec python3 ${./pomodoro-pill.py}";
  };
in
{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${system}.ashell;

    settings = {
      logging = {
        level = "warn";
        target = "stderr";
      };
      position = "Top";
      language = "en-US";
      region = "GR";
      enable_esc_key = true;

      modules = {
        left = [
          "Workspaces"
          "WindowTitle"
        ];
        center = [ "MediaPlayer" ];
        right = [
          "Pomodoro"
          "SystemInfo"
          "KeyboardLayout"
          [
            "Tray"
            "Privacy"
            "Notifications"
            "Settings"
            "Tempo"
          ]
        ];
      };

      media_player = {
        indicator_format = "IconAndText";
        indicator_fields = [ "Title" ];
        max_text_length = 50;
        indicator_visualizer = "Background";
        menu_visualizer = true;
        visualizer_framerate = 30;
      };

      CustomModule = [
        {
          name = "Pomodoro";
          icon = "🍅";
          listen_cmd = "${pomodoro-pill}/bin/pomodoro-pill";
          command = "${tomat}/bin/tomat toggle";
          icons = {
            "^work" = "🍅";
            "^idle" = "🍅";
            "^break" = "🍵";
            "^long-break" = "🍵";
          };
        }
      ];

      workspaces = {
        indicator_format = "NameAndIcons";
        visibility_mode = "All";
        group_by_monitor = false;
        disable_special_workspaces = true;
      };

      window_title = {
        mode = "Title";
        truncate_title_after_length = 75;
      };

      system_info = {
        indicators = [
          "Cpu"
          "Memory"
        ];
        interval = 5;
        cpu = {
          warn_threshold = 60;
          alert_threshold = 80;
        };
        memory = {
          warn_threshold = 70;
          alert_threshold = 85;
        };
        disk = {
          mounts = [
            "/"
            "/home"
          ];
          format = "Fraction";
        };
      };

      keyboard_layout.labels = {
        "English (US)" = "EN";
        "Russian" = "RU";
      };

      tempo = {
        clock_format = "%R";
        timezones = [
          "Europe/Athens"
          "Europe/Berlin"
        ];
        weather_location = {
          City = "Thessaloniki";
        };
        weather_indicator = "Icon";
      };

      notifications = {
        toast = true;
        toast_position = "TopRight";
        toast_timeout = 4000;
        toast_limit = 5;
        toast_max_height = 150;
        grouped = true;
        show_bodies = true;
        show_timestamps = true;
        format = "%H:%M";
        blocklist = [ ];
      };

      settings = {
        lock_cmd = "playerctl --all-players pause; hyprlock &";
        audio_sinks_more_cmd = "pavucontrol -t 3";
        audio_sources_more_cmd = "pavucontrol -t 4";
        wifi_more_cmd = "nm-connection-editor";
        vpn_more_cmd = "nm-connection-editor";
        bluetooth_more_cmd = "blueberry";
        battery_format = "IconAndPercentage";
        remove_airplane_btn = true;
        remove_idle_btn = true;
        indicators = [
          "PowerProfile"
          "Audio"
          "Microphone"
          "Bluetooth"
          "Network"
          "Vpn"
          "Battery"
          "Brightness"
        ];
      };

      osd = {
        enabled = true;
        timeout = 1500;
        show_volume_percentage = true;
        show_brightness_percentage = true;
      };

      animations.enabled = true;

      appearance = {
        bar.surface = "solid";
        scale_factor = 1.2;
        success_color = "#a6e3a1";
        warning_color = "#f9e2af";
        danger_color = "#f38ba8";
        text_color = "#cdd6f4";
        workspace_colors = [
          "#b4befe"
        ];
        primary_color = {
          base = "#b4befe";
          text = "#1e1e2e";
        };
        background_color = {
          base = "#1e1e2e";
          weak = "#313244";
          strong = "#45475a";
        };
      };
    };
  };

  home.packages = [ pkgs.cava ];
}

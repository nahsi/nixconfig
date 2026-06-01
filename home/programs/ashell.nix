{
  programs.ashell = {
    enable = true;
    systemd.enable = true;

    settings = {
      log_level = "warn";
      position = "Top";

      modules = {
        left = [
          "Workspaces"
          "WindowTitle"
        ];
        center = [ "MediaPlayer" ];
        right = [
          "SystemInfo"
          "KeyboardLayout"
          [
            "Tray"
            "Tempo"
            "Privacy"
            "Settings"
          ]
        ];
      };

      workspaces = {
        visibility_mode = "All";
        group_by_monitor = false;
        enable_workspace_filling = true;
      };

      window_title = {
        mode = "Title";
        truncate_title_after_length = 80;
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
      };

      keyboard_layout.labels = {
        "English (US)" = "EN";
        "Russian" = "RU";
      };

      tempo = {
        clock_format = "%a %d %b %R";
      };

      settings = {
        lock_cmd = "playerctl --all-players pause; hyprlock &";
        audio_sinks_more_cmd = "pavucontrol -t 3";
        audio_sources_more_cmd = "pavucontrol -t 4";
        wifi_more_cmd = "nm-connection-editor";
        vpn_more_cmd = "nm-connection-editor";
        bluetooth_more_cmd = "blueberry";
        battery_format = "IconAndPercentage";
        indicators = [
          "IdleInhibitor"
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
      };

      animations.enabled = true;

      appearance = {
        style = "Solid";
        scale_factor = 1.2;
        success_color = "#a6e3a1";
        warning_color = "#f9e2af";
        danger_color = "#f38ba8";
        text_color = "#cdd6f4";
        workspace_colors = [
          "#f5c2e7"
          "#cba6f7"
          "#b4befe"
        ];
        primary_color = {
          base = "#cba6f7";
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
}

{
  inputs,
  system,
  ...
}:
{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${system}.ashell;

    settings = {
      log_level = "warn";
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

      workspaces = {
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
        toast_position = "top_right";
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
}

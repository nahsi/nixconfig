{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = {
        path = "screenshot";
        blur_size = 4;
        blur_passes = 3;
        noise = 1.17e-2;
        contrast = 1.3;
        brightness = 0.8;
        vibrancy = 0.21;
        vibrancy_darkness = 0.0;
      };

      # Time
      label = [
        {
          text = "$TIME";
          font_size = 64;
          position = "0, 75";
          halign = "center";
          valign = "center";
        }

        {
          text = "$USER";
          font_size = 20;
          position = "0, 0";
          halign = "center";
          valign = "center";
        }

        {
          text = "Type to unlock!";
          font_size = 16;
          position = "0, 30";
          halign = "center";
          valign = "bottom";
        }
      ];

      # Password prompt
      input-field = {
        size = "250, 50";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.64;
        dots_center = true;
        fade_on_empty = true;
        placeholder_text = "<i>Password...</i>";
        hide_input = false;
        position = "0, 80";
        halign = "center";
        valign = "bottom";
      };
    };
  };
}

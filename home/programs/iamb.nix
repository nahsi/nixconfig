{
  programs.iamb = {
    enable = true;
    settings = {
      default_profile = "nahsi";
      profiles.nahsi.user_id = "@me:nahsi.dev";
      settings = {
        notifications.enabled = true;
        image_preview.protocol.type = "kitty";
      };
    };
  };
}

_:
{
  # mako stays until ashell 0.9.0 ships its Notifications module
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 3000;
      max-visible = 5;
      max-history = 50;
      group-by = "app-name";

      anchor = "top-right";
      layer = "top";
      margin = 12;

      width = 360;
      height = 140;
      border-size = 2;
      border-radius = 8;
      icons = true;
      max-icon-size = 48;

      "urgency=critical" = {
        default-timeout = 0;
        border-size = 3;
      };
    };
  };
}

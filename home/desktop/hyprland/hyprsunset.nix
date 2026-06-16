{
  services.hyprsunset = {
    enable = true;
    settings = {
      max-gamma = 110;

      profile = [
        {
          time = "07:00";
          identity = true;
        }
        {
          time = "20:00";
          temperature = 4000;
          gamma = 1.0;
        }
      ];
    };
  };
}

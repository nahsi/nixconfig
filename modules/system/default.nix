{ pkgs, lib, ... }:
{
  imports = [
    ./doas.nix
    ./lanzaboote.nix
    ../../fluence
  ];

  time.timeZone = "Europe/Athens";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true;
    earlySetup = false;
  };

  hardware.i2c.enable = true;

  services.libinput.enable = true;

  users.users.nahsi = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    nnn
    pavucontrol
    ddcutil
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "nahsi" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  fonts.fontconfig = {
    enable = true;
  };

  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  # Reducing disk usage
  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;
}

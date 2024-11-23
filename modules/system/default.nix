{ pkgs, ... }:
{
  imports = [
    ./doas.nix
    ./lanzaboote.nix
    ../../orgs/fluence
    ../../orgs/nahsilabs
  ];

  time.timeZone = "Europe/Athens";

  i18n.defaultLocale = "en_DK.UTF-8";

  console = {
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true;
    earlySetup = true;
  };

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  hardware.i2c.enable = true;

  services.libinput.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  users.users.nahsi = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ9opAts/fwt8NkGCtyJ4j9Rzw+WZICC1h91OdEpdK6mdyO4dIkb7mbQLRMNFdKoOnX3AervV5nzI0lEbM4aUVMAYya3V4OX7ZJWIPrnFBjsJuzXtk5qyFYa5ShuOqtWlyDMpY9u7hXaDSnxvMw+opP/CXhZOagBcCbr33IaqBmPxwyNz+9iU6ZNcCy/0AhYOMK8lt830Ekjtu0wreii5x7P6KYEAk6SryvUnnp34reGTftTf7XF6HBUGwFP9ggbPOzVfPH6CqbeUSAT6FHGjKRH8Xvn3bA+v0OdcDOOCZhDr0dPOnJlXDM3XltIDqn3H/ZxOoqabM4KIIIAVHOgov"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoUu5hDFlvZgThaoAuoYvsI5wWETeQfHoR1UX2w0Xdc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILd/6tTC0ZiExgsuvZnJzF32mjFVJBRwZDcUuKb3d5ia"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISV8Fd1iZ8a3Lc9Cb3Ule2M47JGbG8xKMJTSq1ae7ae"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    pavucontrol
    ddcutil
    networkmanagerapplet
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

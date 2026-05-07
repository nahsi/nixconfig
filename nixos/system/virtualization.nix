{ pkgs, ... }:
{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "nahsi" ];
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [ quickemu ];
}

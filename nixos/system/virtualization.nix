{

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "nahsi" ];
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}

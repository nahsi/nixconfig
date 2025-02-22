{
  fileSystems."/home/nahsi/nfs/media/video" = {
    device = "nfs.local:/mnt/storage/users/nahsi/media/video";
    fsType = "nfs4";
    options = [
      "rw"
      "hard"
      "x-systemd.automount"
      "retrans=10"
      "timeo=30"
      "rsize=1048576"
      "wsize=1048576"
      "nfsvers=4.2"
      "noatime"
    ];
  };
  fileSystems."/home/nahsi/nfs/film" = {
    device = "nfs.local:/share/media/film";
    fsType = "nfs4";
    options = [
      "rw"
      "hard"
      "x-systemd.automount"
      "retrans=10"
      "timeo=30"
      "rsize=1048576"
      "wsize=1048576"
      "nfsvers=4.2"
      "noatime"
    ];
  };
}

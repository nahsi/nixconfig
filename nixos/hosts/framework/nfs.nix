let
  nfsMount = path: remotePath: {
    device = "nfs.lan:${remotePath}";
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
in
{
  fileSystems = {
    "/home/nahsi/nfs/media/video" = nfsMount "/home/nahsi/nfs/media/video" "/share/media/video";
    "/home/nahsi/nfs/film" = nfsMount "/home/nahsi/nfs/film" "/share/media/film";
    "/home/nahsi/nfs/media/audiobooks" =
      nfsMount "/home/nahsi/nfs/media/audiobooks" "/share/media/audiobooks";
    "/home/nahsi/nfs/media/podcasts" =
      nfsMount "/home/nahsi/nfs/media/podcasts" "/share/media/podcasts";
  };
}

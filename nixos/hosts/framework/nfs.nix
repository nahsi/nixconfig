let
  nfsMount = path: remotePath: {
    device = "nfs.lan:${remotePath}";
    fsType = "nfs4";
    options = [
      "rw"
      "async"
      "tcp"
      "hard"
      "x-systemd.automount"
      "retrans=10"
      "timeo=30"
      "noatime"
    ];
  };
in
{
  fileSystems = {
    "/home/nahsi/nfs/media/video" = nfsMount "/home/nahsi/nfs/media/video" "/mnt/storage/media/video";
    "/home/nahsi/nfs/media/audiobooks" =
      nfsMount "/home/nahsi/nfs/media/audiobooks" "/mnt/storage/media/audiobooks";
    "/home/nahsi/nfs/media/podcasts" =
      nfsMount "/home/nahsi/nfs/media/podcasts" "/mnt/storage/media/podcasts";
    "/home/nahsi/nfs/media/music" = nfsMount "/home/nahsi/nfs/media/music" "/mnt/storage/media/music";

    "/home/nahsi/nfs/film" = nfsMount "/home/nahsi/nfs/film" "/mnt/storage/media/film";
    "/home/nahsi/nfs/downloads" = nfsMount "/home/nahsi/nfs/downloads" "/mnt/storage/downloads";
  };
}

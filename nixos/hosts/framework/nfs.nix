let
  nfsMount = _path: remotePath: {
    device = "nfs.lan:${remotePath}";
    fsType = "nfs4";
    options = [
      "rw"
      "async"
      "noatime"
      "_netdev"
      "nofail"
      "soft"
      "timeo=30"
      "retrans=3"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "x-systemd.mount-timeout=10s"
    ];
  };
in
{
  fileSystems = {
    "/home/nahsi/nfs/media/video" = nfsMount "/home/nahsi/nfs/media/video" "/mnt/storage/media/video";
    "/home/nahsi/nfs/media/audiobooks" =
      nfsMount "/home/nahsi/nfs/media/audiobooks" "/mnt/storage/media/audiobooks";
    "/home/nahsi/nfs/media/books" = nfsMount "/home/nahsi/nfs/media/books" "/mnt/storage/media/books";
    "/home/nahsi/nfs/media/podcasts" =
      nfsMount "/home/nahsi/nfs/media/podcasts" "/mnt/storage/media/podcasts";
    "/home/nahsi/nfs/media/music" = nfsMount "/home/nahsi/nfs/media/music" "/mnt/storage/media/music";

    "/home/nahsi/nfs/film" = nfsMount "/home/nahsi/nfs/film" "/mnt/storage/media/film";
    "/home/nahsi/nfs/downloads" = nfsMount "/home/nahsi/nfs/downloads" "/mnt/storage/downloads";
    "/home/nahsi/nfs/games/PS2" = nfsMount "/home/nahsi/nfs/games/PS2" "/mnt/storage/games/PS2";
  };
}

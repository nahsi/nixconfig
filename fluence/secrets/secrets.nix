let
  # Users
  nahsi-framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILd/6tTC0ZiExgsuvZnJzF32mjFVJBRwZDcUuKb3d5ia";
  nahsi-system76 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISV8Fd1iZ8a3Lc9Cb3Ule2M47JGbG8xKMJTSq1ae7ae";
  users = [
    nahsi-framework
    nahsi-system76
  ];

  # Systems
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxrlUyNsotE32GC0kY7NvvFkJVixBMJL3BntIifeCzo";
  system76 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNvxsKppOkktYwWU0ZeQCqnrsItecwiWKm2xctaUqsz";
  systems = [
    framework
    system76
  ];
in
{
  "fluence.age".publicKeys = users ++ systems;
  "ssh/hcloud.age".publicKeys = users ++ systems; # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLreheKTTpymlwjdj4g7p4YpYL+PjaseeEHaqIKRRUE
  "vault-agent/role_id.age".publicKeys = users ++ systems;
  "vault-agent/secret_id.age".publicKeys = users ++ systems;
}

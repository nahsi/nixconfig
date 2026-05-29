let
  # Users
  nahsi-framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILd/6tTC0ZiExgsuvZnJzF32mjFVJBRwZDcUuKb3d5ia";
  users = [
    nahsi-framework
  ];

  # Systems
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxrlUyNsotE32GC0kY7NvvFkJVixBMJL3BntIifeCzo";
  systems = [
    framework
  ];
in
{
  "bidpoint-bidpoint.age".publicKeys = users ++ systems;
  "bidpoint-infra.age".publicKeys = users ++ systems;
  "bidpoint-staging.age".publicKeys = users ++ systems;
  "bidpoint-ansible-vault.age".publicKeys = users ++ systems;
}

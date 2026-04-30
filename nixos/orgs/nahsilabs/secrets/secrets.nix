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
  "nahsilabs.age".publicKeys = users ++ systems;
  "singbox.age".publicKeys = users ++ systems;
  "meli-personal-password.age".publicKeys = users ++ systems;
  "meli-trash-password.age".publicKeys = users ++ systems;
}

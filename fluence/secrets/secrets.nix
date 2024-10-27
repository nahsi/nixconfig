let
  # Users
  nahsi-framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILd/6tTC0ZiExgsuvZnJzF32mjFVJBRwZDcUuKb3d5ia";
  users = [ nahsi-framework ];

  # Systems
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxrlUyNsotE32GC0kY7NvvFkJVixBMJL3BntIifeCzo";
  systems = [ framework ];
in
{
  "fluence.age".publicKeys = users ++ systems;
  "vault-agent/role_id.age".publicKeys = users ++ systems;
  "vault-agent/secret_id.age".publicKeys = users ++ systems;
}

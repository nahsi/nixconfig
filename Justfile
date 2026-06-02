default:
  @just --list

build:
  nom build .#nixosConfigurations.framework.config.system.build.toplevel

check:
  nix flake check |& nom

fmt:
  nix fmt

boot:
  nixos-rebuild boot --flake . --sudo |& nom

switch:
  nixos-rebuild switch --flake . --sudo |& nom

debug:
  nixos-rebuild switch --flake . --sudo --show-trace --verbose |& nom

up:
  nix flake update

# Update specific input
# usage: make upp i=home-manager
upp:
  nix flake update $(i)

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  doas nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  doas nix-collect-garbage --delete-old


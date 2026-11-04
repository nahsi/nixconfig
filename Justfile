default:
  @just --list

build:
  nh os build

check:
  nix flake check |& nom

fmt:
  nix fmt

boot:
  nh os boot

switch:
  nh os switch

debug:
  nh os switch --show-trace --verbose

up:
  nix flake update

# Update specific input
# usage: just upp i=home-manager
upp i:
  nix flake update {{i}}

# Add a signed-in download of Tern to the store and print its hash for pkgs/tern
# usage: just tern ~/Downloads/Tern-0.9.11-linux-x86_64.tar.gz
tern file:
  nix-store --add-fixed sha256 {{file}}
  nix hash file --type sha256 --sri {{file}}

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

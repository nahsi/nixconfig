{
  description = "nahsi NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/v25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    inputmodule-control = {
      url = "github:caffineehacker/nix?dir=flakes/inputmodule-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      lanzaboote,
      home-manager,
      ragenix,
      catppuccin,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        kroki-cli = pkgs.callPackage ./pkgs/kroki-cli { };
      };

      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nixos/hosts/framework
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.framework-16-7040-amd
            nixos-hardware.nixosModules.common-hidpi
            ragenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs system;
                  hostConfig = {
                    fontSize = "14";
                    qutebrowserZoom = "125%";
                  };
                };
                users.nahsi = {
                  imports = [ ./home-manager ];
                };
              };
            }
          ];
        };

        system76 = nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nixos/hosts/system76
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.system76
            ragenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs system;
                  hostConfig = {
                    fontSize = "12";
                    qutebrowserZoom = "100%";
                  };
                };
                users.nahsi = {
                  imports = [ ./home-manager ];
                };
              };
            }
          ];
        };
      };
    };
}

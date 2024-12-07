{
  description = "nahsi NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
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
      spicetify-nix,
      nixvim,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostConfig = {
                  fontSize = "14";
                  qutebrowserZoom = "125%";
                };
              };
              home-manager.users.nahsi = {
                imports = [ ./home-manager ];
              };
            }
          ];
        };
        system76 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostConfig = {
                  fontSize = "12";
                  qutebrowserZoom = "100%";
                };
              };
              home-manager.users.nahsi = {
                imports = [ ./home-manager ];
              };
            }
          ];
        };
      };
    };
}

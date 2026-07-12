{
  description = "nahsi NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
      url = "github:catppuccin/nix/v26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mattpocock-skills = {
      url = "github:mattpocock/skills/v1.0.1";
      flake = false;
    };

    caveman = {
      url = "github:juliusbrussee/caveman/v1.8.2";
      flake = false;
    };

    omp-nix.url = "git+https://git.molez.org/mandlm/omp-nix?ref=refs/tags/v16.4.6";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      lanzaboote,
      home-manager,
      ragenix,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
        flavor = "claude-code";
        programs.nixos.enable = true;
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    in
    {
      packages.${system} = {
        kroki-cli = pkgs.callPackage ./pkgs/kroki-cli { };
        ferrosonic-ng = pkgs.callPackage ./pkgs/ferrosonic-ng { };
        kubernetes-mcp-server = pkgs.callPackage ./pkgs/kubernetes-mcp-server { };
        mcp-victorialogs = pkgs.callPackage ./pkgs/mcp-victorialogs { };
        mcp-victoriametrics = pkgs.callPackage ./pkgs/mcp-victoriametrics { };
        tanin = pkgs.callPackage ./pkgs/tanin { };
      };

      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system}.formatting = treefmtEval.config.build.check self;

      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          nix-store --add-root .mcp.json --indirect --realise ${mcpConfig}
        '';
      };

      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          inherit system;
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
                };
                users.nahsi = {
                  imports = [ ./home ];
                };
              };
            }
          ];
        };

      };

      homeConfigurations.nahsi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home ];
        extraSpecialArgs = {
          inherit inputs system;
          osConfig = self.nixosConfigurations.framework.config;
        };
      };
    };
}

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
      url = "github:nix-community/lanzaboote/v1.1.0";
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
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

    omp.url = "github:can1357/oh-my-pi/v18.8.7";

    led-matrix-monitoring = {
      url = "github:MidnightJava/led-matrix";
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
        programs.nixfmt.enable = true;
      };
    in
    {
      packages.${system} = {
        negpy = pkgs.callPackage ./pkgs/negpy { };
        kroki-cli = pkgs.callPackage ./pkgs/kroki-cli { };
        ferrosonic-ng = pkgs.callPackage ./pkgs/ferrosonic-ng { };
        mcp-victorialogs = pkgs.callPackage ./pkgs/mcp-victorialogs { };
        mcp-victoriametrics = pkgs.callPackage ./pkgs/mcp-victoriametrics { };
        wayfinder-maps = pkgs.callPackage ./pkgs/wayfinder-maps { };
      };

      formatter.${system} = treefmtEval.config.build.wrapper;

      # Keep formatting separate from lint warnings that have no automatic fix.
      checks.${system} = {
        formatting = treefmtEval.config.build.check self;
        lint = inputs.git-hooks.lib.${system}.run {
          src = self;
          hooks = {
            statix.enable = true;
            deadnix.enable = true;
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          treefmtEval.config.build.wrapper
        ]
        ++ self.checks.${system}.lint.enabledPackages;

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

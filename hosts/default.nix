{ lib, inputs, nixpkgs, home-manager, nur, user, location, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
  go-overlay = final: prev: {
    golines = pkgs.buildGo118Module rec {
      pname = "golines";
      version = "0.10.0";
      src = pkgs.fetchFromGitHub {
        owner = "segmentio";
        repo = "golines";
        rev = "v${version}";
        sha256 = "sha256-Mi3LBE4+LWmNwyMeLr3ucMictMMQv2vzfWtJyCfOsHE=";
      };
      vendorSha256 = "sha256-rxYuzn4ezAxaeDhxd8qdOzt+CKYIh03A9zKNdzILq18=";
    };

    gow = pkgs.buildGo118Module rec {
      pname = "gow";
      version = "0.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "mitranim";
        repo = "gow";
        rev = "e9d92c985e03650350703af63f72c4f2be5a1e79";
        sha256 = "sha256-QUIEWjY5yYIidj2yjO5SdSfCqr4TQD9M4d3q7VTI3ps=";
      };
      vendorSha256 = "sha256-o6KltbjmAN2w9LMeS9oozB0qz9tSMYmdDW3CwUNChzA=";
    };
  };
in {
  old-thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user location; };
    modules = [
      nur.nixosModules.nur
      ./old-thinkpad
      ./configuration.nix
      ({ config, pkgs, ... }: {
        nixpkgs.overlays = [ go-overlay inputs.nvim-overlay.overlay ];
      })

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ]
            ++ [ (import ./old-thinkpad/home.nix) ];
        };
      }
    ];
  };

  tombook = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user location; };
    modules = [
      nur.nixosModules.nur
      ./tombook
      ./configuration.nix
      ({ config, pkgs, ... }: { nixpkgs.overlays = [ go-overlay ]; })

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ] ++ [ (import ./tombook/home.nix) ];
        };
      }
    ];
  };

  workbook = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user location; };
    modules = [
      nur.nixosModules.nur
      ./workbook
      ./configuration.nix
      ({ config, pkgs, ... }: { nixpkgs.overlays = [ go-overlay ]; })

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ] ++ [ (import ./workbook/home.nix) ];
        };
      }
    ];
  };
}

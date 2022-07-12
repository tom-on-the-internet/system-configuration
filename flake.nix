# This is my NixOS configuration
# I based this entirely on https://github.com/MatthiasBenaets/nixos-config
# He has a great video tutorial available at https://www.youtube.com/watch?v=AGVXJ-TIv3Y
{
  description = "Tom's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = { url = "github:nix-community/NUR"; };

    nixgl = {
      # OpenGL
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad.url = "github:kmonad/kmonad?dir=nix";

    nvim-overlay = { url = "github:nix-community/neovim-nightly-overlay"; };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, nixgl, ... }:
    let
      user = "tom";
      location = "$HOME/.setup";

    in
    {
      nixosConfigurations = import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager nur user location;
      };
    };
}

# Home-manager configuration for old-laptop

{ pkgs, ... }:

{
  imports = [
    ../../modules/desktop/hyprland/home.nix # Window Manager
  ];

  home = { # Specific packages for old-laptop
    packages = with pkgs; [ ];
  };
}

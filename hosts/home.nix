{ config, lib, pkgs, user, ... }:

{
  imports = (import ../modules/editors) ++ (import ../modules/programs)
    ++ (import ../modules/services) ++ (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      feh
      google-chrome
      mpv
      pavucontrol
      pcmanfm
      rsync
      unrar
      unzip
    ];
    stateVersion = "22.05";
  };

  programs = { home-manager.enable = true; };

  services = {
    blueman-applet.enable = true; # Bluetooth
    network-manager-applet.enable = true; # Network
  };
}

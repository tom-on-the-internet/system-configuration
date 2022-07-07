{ config, lib, pkgs, user, ... }:

{
  imports = (import ../modules/programs) ++ (import ../modules/services)
    ++ (import ../modules/shell) ++ [ ../modules/desktop/sway/home.nix ]
    ++ [ ../modules/desktop/sway/rofi.nix ]
    ++ [ ../modules/desktop/sway/mako.nix ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      asciiquarium
      bat
      exa
      feh
      go_1_18
      golines
      gow
      gnumake
      kdenlive
      killall
      mpv
      nixfmt
      pavucontrol
      pcmanfm
      ripgrep
      rsync
      slack
      tealdeer
      unrar
      unzip
    ];

    file.".config/wall".source = ../rsc/wall;

    stateVersion = "22.05";
  };

  programs = {
    home-manager = { enable = true; };
    google-chrome = { enable = true; };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    wlsunset = {
      enable = true;
      latitude = "27.2";
      longitude = "77.5";
    };
  };
}

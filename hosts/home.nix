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
      gcc
      gnumake
      go_1_18
      golangci-lint-langserver
      golines
      gopls
      gotest
      gotests
      gotools
      gow
      hadolint
      kdenlive
      killall
      mdl
      mpv
      nixfmt
      nodePackages.eslint_d
      nodePackages.prettier
      node2nix
      nodejs
      pavucontrol
      pcmanfm
      ripgrep
      rsync
      shellcheck
      shfmt
      slack
      stylua
      tealdeer
      unrar
      unzip
      yarn2nix
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

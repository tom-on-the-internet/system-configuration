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
      btop
      exa
      fd
      feh
      gcc
      gimp
      gnumake
      go_1_18
      gofumpt
      golangci-lint
      golangci-lint-langserver
      golines
      gopls
      gotest
      gotests
      gotools
      gow
      hadolint
      kdenlive
      ksnip
      killall
      mdl
      mpv
      nixfmt
      node2nix
      nodePackages.eslint_d
      nodePackages.prettier
      nodejs
      pavucontrol
      pcmanfm
      pinta
      ripgrep
      rofimoji
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
      latitude = "43.20";
      longitude = "-79.23";
    };
  };
}

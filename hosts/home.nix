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
      file
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
      grc
      hadolint
      kanshi
      kdenlive
      killall
      ksnip
      mdl
      mpv
      nixfmt
      node2nix
      nodePackages.eslint_d
      nodePackages.intelephense
      nodePackages.prettier
      nodejs
      pcmanfm
      pulsemixer
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
    kanshi = {
      enable = true;
      profiles = {
        laptop = {
          outputs = [{
            criteria = "eDP-1";
            status = "enable";
          }];
        };
        desktop = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "BenQ Corporation BenQ LCD DAJ00379019";
              status = "enable";
            }
          ];
        };
      };
    };
  };
}

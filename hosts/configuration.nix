{ config, lib, pkgs, inputs, user, location, ... }:

{
  imports = [
    ../modules/dropbox
    inputs.kmonad.nixosModules.default
    ../modules/desktop/sway/sway.nix
    ../modules/desktop/sway/waybar.nix
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "camera"
      "docker"
      "kvm"
      "lp"
      "networkmanager"
      "scanner"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Canada/Eastern"; # Time zone and internationalisation
  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    font = "ter-powerline-v24b";
    packages = [ pkgs.terminus_font pkgs.powerline-fonts ];
  };

  security.rtkit.enable = true;

  sound = {
    enable = true;
    mediaKeys = { enable = true; };
  };

  fonts = {
    fonts = with pkgs; [
      carlito
      corefonts
      dina-font
      font-awesome
      google-fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      proggyfonts
      vegur
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hermit" ]; })
    ];

    enableDefaultFonts = true;
    fontDir.enable = true;

    fontconfig = {
      defaultFonts = {
        # serif = [ "Vazir" "Ubuntu" ];
        # sansSerif = [ "Vazir" "Ubuntu" ];
        monospace = [ "Hurmit Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  environment = {
    variables = {
      TERMINAL = "foot";
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [ git light pamixer udiskie vim wget ];
  };

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    openssh = { enable = true; };

    kmonad = {
      enable = true;

      keyboards.internal = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ../rsc/tom.kbd;

        defcfg = {
          enable = true;
          fallthrough = true;
        };
      };

      keyboards.shinobi = {
        device = "/dev/input/by-path/pci-0000:00:14.0-usb-0:1.2:1.0-event-kbd";
        config = builtins.readFile ../rsc/tom.kbd;

        defcfg = {
          enable = true;
          fallthrough = true;
        };
      };
    };
  };

  nix = {
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  nixpkgs.config = { allowUnfree = true; };

  networking = {
    useDHCP = false; # Deprecated
    networkmanager.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    auto-cpufreq.enable = true;
    blueman.enable = true;
    dbus.enable = true;
    deluge.enable = true;
    tlp.enable = true;
  };

  virtualisation.docker.enable = true;

  system = {
    # NixOS settings
    autoUpgrade = {
      # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };

  boot = { kernelPackages = pkgs.linuxPackages_latest; };
}

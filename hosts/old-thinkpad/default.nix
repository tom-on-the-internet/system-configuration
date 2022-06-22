# Specific system configuration settings for old-thinkpad

{ config, pkgs, user, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ]
    ++ [ (import ../../modules/desktop/hyprland/hyprland.nix) ]
    ++ (import ../../modules/hardware);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      grub = {
        enable = true;
        version = 2;
        devices = [ "/dev/sda" ];
        configurationLimit = 5;
      };
    };
  };

  environment = { systemPackages = with pkgs; [ simple-scan ]; };

  programs = { # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    tlp.enable = true; # TLP and auto-cpufreq for power management
    auto-cpufreq.enable = true;
    blueman.enable = true;
  };
}

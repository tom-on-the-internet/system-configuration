{ config, pkgs, user, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ]
    ++ (import ../../modules/hardware);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      grub = {
        enable = true;
        version = 2;
        devices = [ "/dev/sda" ];
        configurationLimit = 10;
      };
    };
  };

  environment = { systemPackages = with pkgs; [ ]; };

  networking.hostName = "old-thinkpad";
}

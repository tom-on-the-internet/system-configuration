{ config, pkgs, user, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ]
    ++ (import ../../modules/hardware);

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };

      efi.canTouchEfiVariables = true;
    };
  };

  environment = { systemPackages = with pkgs; [ ]; };

  networking.hostName = "tombook";

  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}

{ pkgs, ... }:

{
  imports = [ ];

  home = { packages = with pkgs; [ ]; };

  programs.git = {
    userName = "Thomas Steven";
    userEmail = "thomas@humi.ca";
  };
}

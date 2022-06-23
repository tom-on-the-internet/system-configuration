{ pkgs, ... }:

{
  programs = {
    mako = {
      enable = true;
      backgroundColor = "#161417";
      borderColor = "#88b18f";
      borderSize = 1;
      defaultTimeout = 6000;
      font = "monospace 15";
      height = 200;
      margin = "10";
      maxVisible = 4;
      padding = "10";
      textColor = "#f7faf3";
    };
  };
}

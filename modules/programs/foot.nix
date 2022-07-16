{ pkgs, ... }:

{
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          font = "monospace:size=12";
          line-height = "16";
        };

        colors = {
          alpha = "0.95";
          background = "161417";
          foreground = "f7faf3";

          regular0 = "161417";
          regular1 = "d06e76";
          regular2 = "88b18f";
          regular3 = "e2c082";
          regular4 = "68a8dc";
          regular5 = "a280be";
          regular6 = "5eb2bb";
          regular7 = "a6a9a1";

          bright0 = "69676a";
          bright1 = "87353d";
          bright2 = "436349";
          bright3 = "917442";
          bright4 = "2a5d84";
          bright5 = "5b4072";
          bright6 = "256b71";
          bright7 = "f7faf3";

        };
        scrollback = { lines = "20000"; };
      };
    };
  };
}

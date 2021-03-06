{ home, pkgs, lib, ... }:
let
  concatFiles = files:
    let
      wrapLua = contents:
        ''
          lua << EOF
        '' + contents + ''

          EOF
        '';

      read = file:
        if pkgs.lib.hasSuffix ".lua" file then
          wrapLua (builtins.readFile file)
        else
          builtins.readFile file;
    in
    pkgs.lib.strings.concatMapStringsSep "\n" read files;

in
{
  home.file = {
    ".config/golangci/golangci.yaml".text = ''
      output:
        format: json
      linters:
        enable-all: true
        disable:
          - dupl
          - exhaustivestruct
          - exhaustruct
          - forbidigo
          - lll
          - tagliatelle
      linters-settings:
        nlreturn:
          block-size: 2
        varnamelen:
          ignore-names:
            - tc
          ignore-decls:
            - w http.ResponseWriter
            - r *http.Request
            - is *is.I
            - wg sync.WaitGroup
    '';
  };
  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [ ];

    plugins = with pkgs.vimPlugins; [{ plugin = telescope-fzf-native-nvim; }];

    extraConfig = (concatFiles [
      ./vim/bootstrap.vim
      ./vim/init.vim
      ./vim/helpers.lua
      ./vim/plugins.lua
      ./vim/lsp.lua
    ]) + ''
      " You can add more here if you need to access nix variables
    '';

    #tom, why node js?
    withNodeJs = true;
  };
}

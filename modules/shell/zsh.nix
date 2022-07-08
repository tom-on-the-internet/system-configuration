{ config, pkgs, commands, ... }:

{
  programs = {

    zsh = {
      enable = true;
      dotDir = ".config/zsh_nix";
      shellAliases = {
        calc = "bc --mathlib";
        cat = "bat";
        cp = "cp -riv";
        dc = "docker compose";
        e = "nvim";
        ec = "nvim --clean";
        ll = "ls -al";
        ls = "exa --group-directories-first --icons --color-scale";
        mkdir = "mkdir -vp";
        mv = "mv -iv";
        rm = "rm -v";
        ssh = "kitty +kitten ssh";
        tn = "nvim ~/Dropbox/notes/notes.txt";
        tree = "tree -C -a";
        wn = "nvim ~/Dropbox/notes/work-notes.txt";
      };
      shellGlobalAliases = {
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        "......" = "../../../../..";
      };
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "caa749d030d22168445c4cb97befd406d2828db0";
            sha256 = "YV9lpJ0X2vN9uIdroDWEize+cp9HoKegS3sZiSpNk50=";
          };
        }
      ];

      history = {
        size = 10000;
        save = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      initExtra = ''
        stty stop undef		# Disable ctrl-s to freeze terminal.
        bindkey -e # emacs mode

        setopt appendhistory
        setopt COMPLETE_ALIASES
        setopt SHARE_HISTORY
        setopt HIST_IGNORE_DUPS

        # Basic auto/tab complete:
        autoload -U compinit
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)		# Include hidden files.
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = { enable = true; };
  };

}

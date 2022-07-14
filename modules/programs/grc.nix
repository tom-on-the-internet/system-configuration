{ home, pkgs, lib, ... }: {
  home.file = {
    ".grc/grc.conf".text = ''
      # Go
      \bgo.* test\b
      conf.gotest
    '';
    ".grc/conf.gotest".text = ''
      regexp==== RUN .*
      colour=blue
      -
      regexp=--- PASS: .*
      colour=green
      -
      regexp=^PASS$
      colour=green
      -
      regexp=^(ok|\?) .*
      colour=magenta
      -
      regexp=--- FAIL: .*
      colour=red
      -
      regexp=^FAIL.*
      colour=red
      -
      regexp=[^\s]+\.go(:\d+)?
      colour=cyan
    '';
  };
}

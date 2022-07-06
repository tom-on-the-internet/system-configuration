{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "golines";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "golines";
    rev = "v${version}";
    sha256 = "sha256-6IzUpAsFUgF2FwiC17OfDn1M+8WYFQPpRyXbkpHIztw=";
  };

  vendorSha256 = "sha256-WMeHZN3s+8pIYEVaSLjI3Bz+rPTWHr1AkZ8lydjBwCw=";

  # tests are broken in nix environment
  doCheck = false;

  meta = with lib; {
    description =
      "Golines is a golang formatter that shortens long lines, in addition to all of the formatting fixes done by gofmt.";
    homepage = "https://github.com/segmentio/golines";
  };
}

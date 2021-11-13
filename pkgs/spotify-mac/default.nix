{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.71.560.gc21c3367-40";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://download.scdn.co/Spotify.dmg";
    sha256 = "1m8a2rj1pwxcmszsnnx5m2sg3ipwdfg4zd4879r2r35s2bwsdv91";
  };

  meta = {
    homepage = "https://spotify.com";
    license = lib.licenses.unfree;
  };
}

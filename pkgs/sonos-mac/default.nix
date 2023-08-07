{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "15.6";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/srahdpcj/Sonos_74.0-43110.dmg";
    sha512 = "sha512-2gIlOEm2XD5NbpFfwjUK1THHzvSk6wIsxDf6brbrT3XzizrVJ9Q2yyccwmh7V8oiacolJn+lGpTZWKV9aHpn6A==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

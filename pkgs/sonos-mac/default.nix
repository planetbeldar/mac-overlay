{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "15.1.1";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/veqbtaxi/Sonos_71.1-38240.dmg";
    sha512 = "sha512-Fhm9Vyb73uMuwCxjKOSTlDH1Ppx86lFxjk6gbdI98hOTHTHFB1lR0bEfY+zXvCmFrbHk6o5Jv43h1QGKHDSWQA==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

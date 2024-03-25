{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "16.1";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/nvasc21FQF/Sonos_78.1-51030.dmg";
    sha512 = "sha512-QL6totST796OioQlm9eLfswgjBxKxR9NsgCkLyM96cDAs5ySWKuw1/3a9UnVFkYrylIFMZ0V35HHffMxB2Awcw==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.10";

  fileVersion = builtins.replaceStrings [ "." ] [ "" ] version;
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://update.sonos.com/software/mac/mdcr/SonosDesktopController${fileVersion}.dmg";
    sha512 = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

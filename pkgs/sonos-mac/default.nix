{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.6";

  fileVersion = builtins.replaceStrings [ "." ] [ "" ] version;
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://update.sonos.com/software/mac/mdcr/SonosDesktopController${fileVersion}.dmg";
    sha512 = "5TS1FWfTOiZmyj/g1Hu1v+Iceg9UPuocwnFM35B68E+3maRfRaL/2LFPpJCYGgurMMVOe/PxqljrSILp9dvoAw==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

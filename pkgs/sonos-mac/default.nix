{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.4";

  fileVersion = builtins.replaceStrings [ "." ] [ "" ] version;
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://update.sonos.com/software/mac/mdcr/SonosDesktopController${fileVersion}.dmg";
    sha512 = "6Pdl8mlE9NBXTrpXkkur/geeRcdqyMCwDYbKC2ErOiAnLjveXGcp8/zND6JbaCN1WrnIXnvi4jQEOrhiI+zGzg==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

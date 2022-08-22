{ lib, stdenv, fetchurl }:
let
  inherit (lib.lists) take last;
  inherit (lib.strings) splitString;
  inherit (builtins) concatStringsSep;

  pname = "sonos";
  version = "14.12,69.1.31120";

  versions = splitString "," version;
  fileVersion = let
    versionNumbers = splitString "." (last versions);
  in "${concatStringsSep "." (take 2 versionNumbers)}-${last versionNumbers}";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://update-software.sonos.com/software/flfowmpo/Sonos_${fileVersion}.dmg";
    sha512 = "rZrfeuy3oXIJrddMuRDQhRynCTg/dEvtJx6h63iyqbg357L7X0Dc9JvnydwQbv3pHG2KIc9fOxJqP/H/xZOXkQ==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

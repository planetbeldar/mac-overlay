{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.8";

  fileVersion = builtins.replaceStrings [ "." ] [ "" ] version;
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://update.sonos.com/software/mac/mdcr/SonosDesktopController${fileVersion}.dmg";
    sha512 = "Aexz1sLw1+Rv7qsY7YAdJvUY7j0k6PfZVwv5+ZnKVSh6DgM+wv4BE8tgqQSSqsiBEsFg/+suAllqEdshCUqTnw==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

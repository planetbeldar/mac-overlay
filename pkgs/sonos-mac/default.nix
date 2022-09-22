{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.16";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/gjocspcx/Sonos_69.1-33120.dmg";
    sha512 = "sha512-k9Gt3uxmQhVhB3aKdkSEhJW3tuVmghyfR/HnuWEvfhAYYFXlZYklgzCyvyP8gm4USDO0439TjgcxQL3JyHE2sA==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

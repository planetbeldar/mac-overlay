{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.18";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/imaqiycw/Sonos_70.1-34112.dmg";
    sha512 = "sha512-mZsiCkwpOrVSQ72AF1/Fsc3JnhKR+vfJKN9bF5gqKCnUfLnYVi/EM2HyJNU9ojFfoPewe35kKQRIFK23KV4fJQ==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

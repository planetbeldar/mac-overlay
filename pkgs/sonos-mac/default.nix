{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "16.2";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/6T0nrTOYJg/Sonos_79.1-53290.dmg";
    sha512 = "sha512-fl/i8KozqNqlCZRUwG+nmEQyKSbgHuMi5eNct2ErfpVjHIqLPptOvplj8Y2+jMgQK7YYswPC3B0fd3Efluyi4w==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.15";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/bzxztwjn/Sonos_69.1-32152.dmg";
    sha512 = "sha512-tiMcV1Gf0uhcWI9e3bdsXfDVawynSb6bywDzC3FV3m4yL0OWcU6y9YIlVccgx/t0KSc+RnO3ekGhwg0UhcqgXQ==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

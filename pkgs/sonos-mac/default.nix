{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "15.8";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/fnwewsgg/Sonos_75.1-45120.dmg";
    sha512 = "sha512-tkwmSMgOZdQ4r2rfE4d7K8aYlPTS8Rd2JWbcNa+TSBoXU9dPxCgRg5KuSn3+B7hpa6nwB0WvSZAWIcZZKRw31Q==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

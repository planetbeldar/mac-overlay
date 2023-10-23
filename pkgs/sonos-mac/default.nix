{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "15.9";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/irbxsaud/Sonos_75.1-46030.dmg";
    sha512 = "sha512-oCpOQW35LLVibeeL+Fo+ZiKyMj4bde17Y2yUx3bkrTR7NqdRmxZoptd8avcEC6BOKlBITfTnnHZRhkXO5tbdNg==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "13.3.2";

  fileVersion = builtins.replaceStrings [ "." ] [ "" ] version;
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://update.sonos.com/software/mac/mdcr/SonosDesktopController${fileVersion}.dmg";
    sha256 = "2a0f2aebe3e10c52c3905d0f6eb7a060903f486ec418bc2ba895d7feef7e46e0";
  };

  meta = {
    homepage = "https://sonos.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "15.2";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/vgnciqkn/Sonos_72.2-39150.dmg";
    sha512 = "sha512-A24HDdMj+aJl9dv0WX7DZhJZyW8ojcTOblUmpc0HA4L+a3vz0rGo0BqrQkJUvLwNQidedX5OocjkctlTHaQ+hg==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

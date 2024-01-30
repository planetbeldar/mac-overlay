{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "15.11";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/zypefwbr/Sonos_76.2-47270.dmg";
    sha512 = "sha512-Qjc39oIJ15LvnMDKDJD8z65iQvS6TK5l3BqPKHmh12cH0575M6P+TlhRZXqypnY8DSNm4pBL1iXcQBTpztshvw==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

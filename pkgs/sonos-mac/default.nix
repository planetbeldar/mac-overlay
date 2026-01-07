{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "17.2";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/ZethjbGivZ/Sonos_90.0-67171.dmg";
    sha512 = "sha512-17mhr59AqjKTFVEH7SjHLq3Ol69ssiGCduEh6vBWAXNQymAc2YhcY/qxIP6xKMzyhKu2ojMJzhhSpLMF17a0CA==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

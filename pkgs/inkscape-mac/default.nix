{ lib, stdenv, fetchurl }:
let
  pname = "inkscape";
  version = "1.1.2";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/Inkscape-${version}.dmg";
    sha256 = "WvL8+mXGjHaIuGK6nFCRmb4hlU8ozPu31ABM+T008Yo=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.inkscape.org";
    description = "Inkscape is a Free and open source vector graphics editor for GNU/Linux, Windows and MacOS X";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

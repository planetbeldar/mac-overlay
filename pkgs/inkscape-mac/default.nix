{ lib, stdenv, fetchurl }:
let
  pname = "inkscape";
  version = "1.3.2";

  url = arch: "https://media.inkscape.org/dl/resources/file/Inkscape-${version}_${arch}.dmg";
  src = {
    x86_64-darwin = {
      url = url "x86_64";
      sha512 = "23n7b6gmk4fjw4cgsid3v0kss4vxhag44g105kmjy1jvjh39idjyqx40kj9b6lqgb9d362bili75fpwiv8d82z7h797krixrvbfjwxg";
    };
    aarch64-darwin = {
      url = url "arm64";
      sha512 = "2rppf6q0zi0q4lz5r6hwn5ikf0ijxpm7lwrv54f6xmvrbmk3y14ic177zhrx16xs88gdl9a2rz42w59g4mi87mqw58z2q4b51cra80b";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl src;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.inkscape.org";
    description = "Inkscape is a Free and open source vector graphics editor for GNU/Linux, Windows and MacOS X";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "inkscape";
  version = "1.2.0";

  url = arch: "https://media.inkscape.org/dl/resources/file/Inkscape-${version}_${arch}.dmg";
  src = {
    x86_64-darwin = {
      url = url "x86_64";
      sha512 = "3ajj0620c1m0060gkk43is10cq3yq861ps3hcxn7iqfddnvdndyszj4m3lvkmp0bcga1icv2s5zm6988xky95jfqqjl1s922avxsin7";
    };
    aarch64-darwin = {
      url = url "arm64";
      sha512 = "12amc116pgs9gw0anbbpf4bv11kfai92s2j4sgcm51ibfnl0xl71l8n3j4x01sl2ji9shz0hw66x4pkm37bl2iyf74rds78ybxd5nqb";
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

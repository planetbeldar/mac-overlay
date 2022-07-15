{ lib, stdenv, fetchurl }:
let
  pname = "inkscape";
  version = "1.2.1";

  url = arch: "https://media.inkscape.org/dl/resources/file/Inkscape-${version}_${arch}.dmg";
  src = {
    x86_64-darwin = {
      url = url "x86_64";
      sha512 = "3g0yzaawhqf2x9ilbvwspd0dnfijp345ajaflqcyps2ywb9bhxl4z980aw8ws97i4xbsk1i1svasizdmiwrqcx8cc64q5fn07y5af1d";
    };
    aarch64-darwin = {
      url = url "arm64";
      sha512 = "2kn9450xgav2m062r6l9wjlh1gyx404rsdiv24mpqf4gsp63jvq7d2h4b5n9l8qlc3jmwxnxrkdspx7cvh2mxibz2a9ashyyah1xp7l";
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

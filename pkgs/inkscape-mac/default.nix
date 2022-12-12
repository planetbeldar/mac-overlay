{ lib, stdenv, fetchurl }:
let
  pname = "inkscape";
  version = "1.2.2";

  url = arch: "https://media.inkscape.org/dl/resources/file/Inkscape-${version}_${arch}.dmg";
  src = {
    x86_64-darwin = {
      url = url "x86_64";
      sha512 = "31bhhh9l2m3nv5y8i1r1lxz8hpbbvy0dxf7iwzsw5l22gzvag6gl8zc9n15crzrxivp07qf0vwagkzsgjv7br833xk980z5m0x3bypm";
    };
    aarch64-darwin = {
      url = url "arm64";
      sha512 = "079r34arffldlz7j6rajff3zaljipl6nd2y8c5dn7ls3d3wnp09yn06nr8nq2pcwdaav2vsy3kgayzphy2n790kxpin2rh6laj2ad0b";
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

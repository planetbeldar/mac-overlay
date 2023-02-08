{ lib, stdenv, fetchurl }:
let
  pname = "fleet";
  version = "1.14.78";

  sha256 = {
    x64 = "eea429104e309eb2853039df5b80df31d0fcdeeadee88cf7a54c2e62a6d83347";
    aarch64 = "593fe65fde8a6cb6a5b880b8fc132d18fb146cec356fd3a887690db49e7bb8ab";
  };

  hostSystem = stdenv.hostPlatform.system;
  platform = {
    x86_64-darwin = "x64";
    aarch64-darwin = "aarch64";
  }.${hostSystem} or (throw "Unsupported system: ${hostSystem}");

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://download.jetbrains.com/fleet/installers/macos_${platform}/Fleet-${version}-${platform}.dmg";
    sha256 = sha256.${platform} or (throw "Missing hash for host sytem ${hostSystem}");
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.jetbrains.com/fleet/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

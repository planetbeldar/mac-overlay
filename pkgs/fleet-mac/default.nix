{ lib, stdenv, fetchurl }:
let
  pname = "fleet";
  version = "1.48.261";

  sha256 = {
    x64 = "5a0fddbdbd28f108ecaee818e3859028cf215a7aa001c04163fe3800fb6da1b6";
    aarch64 = "09e0d68820830e3ef43161f1d3d39a5ff3075ae90b0bfaa48b9b33a6bcf5d4ae";
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

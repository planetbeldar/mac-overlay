{ lib, stdenv, fetchurl }:
let
  pname = "fleet";
  version = "1.36.103";

  sha256 = {
    x64 = "4ca3b03f046ebe7c8c41be9b38facc913bb4cdcf2cbd1a3e41042ab64f4bc305";
    aarch64 = "fa218751dd52ee05926d95eb0568b706a7c94ee99af2ab2357698c7fe3df4ecc";
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

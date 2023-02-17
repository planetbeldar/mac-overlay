{ lib, stdenv, fetchurl }:
let
  pname = "fleet";
  version = "1.15.69";

  sha256 = {
    x64 = "71b97e5a93a0768417b7b5c7107625ac0383935e52df1ff7492af745c158123a";
    aarch64 = "e4a306a798438c541897412399a2f636e3aff5ff3b7eef04ffee9c186b46ae5c";
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

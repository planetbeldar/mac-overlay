{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.272";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "AS9bru7/PSquZVfR/wwTT5tuC+H1sK16FcuqDwx7avU=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

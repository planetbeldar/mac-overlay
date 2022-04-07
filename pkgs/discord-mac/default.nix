{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.266";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "yjBJE61qZtjxevD4SGiA+ImI+02Ue42FhCFTFxXFKcQ=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

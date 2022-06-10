{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.267";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "EyBXavXHwAtZuXPl7H7SAyLOkfaxiJaigqmnZlv68OA=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

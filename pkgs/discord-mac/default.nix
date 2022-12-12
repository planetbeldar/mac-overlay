{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.270";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "Hb8GZgsG3WCIcTUnyqYK80e5WlIY/7LCtsG69RSvUhs=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

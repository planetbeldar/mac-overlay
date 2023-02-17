{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.273";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "VHlPv0spyaVvbopzb/VEXHWh/Tz0nc57TXqm/wZ64u8=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

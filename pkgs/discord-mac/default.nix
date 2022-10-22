{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.269";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "u3nhjLedD1WNwlrTH8rS2VO8wtabRajCBjmPLXuOhBM=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

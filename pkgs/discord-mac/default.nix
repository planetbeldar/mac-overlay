{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.264";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "f7e8e401d1d1526eef3176cd75e38807cf73e25c4fe76b42d65443ec56ed74cb";
  };

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

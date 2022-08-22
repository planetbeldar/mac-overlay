{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.268";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "3+EjFbcX7QasJNPqrLcAYY6Wy7RJ7WPSr63NtwrQnFU=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.307";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "FBYxQhtwctMQ8ByOgAVncWh5297k1Vh95w/rWnZg9Fw=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.297";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "ARXKLpfB3xpa8C/17p7ONJAySnt8/A+wgOMe9J9hFj8=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

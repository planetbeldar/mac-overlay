{ lib, stdenv, fetchurl }:
let
  pname = "discord";
  version = "0.0.276";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "JSf4cxDkgnL52XO3eu9F2WMpc9qcWGW1R+9og/UJ6/I=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
  };
}

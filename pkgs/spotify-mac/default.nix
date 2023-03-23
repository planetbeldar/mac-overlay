{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.7.1277.g2b3ce637-220";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-QjfBvpg4Elu+n8fI0XDtq+fMemdcNsTZI6Zv743AIcInm0bo4K9OXpRgzZ/FVOo3gklFqmzYaYkcVjlGU6vwWA==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-dk7HKWggnjxg7se4qsU5VMw6gUUss5Or6avGkoh/VEwGqK93li7lHDJkRv9CvN1DYXB2g4JJrsMe70uGNrARng==";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl src;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.spotify.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

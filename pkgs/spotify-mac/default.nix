{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.94.870.gf994cb0b-16";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-roxvitM1issUzN75voj1KL04Nqw2cxYLexk9eTLZ80CAZbDLcSwusclS76kvL4j+Dq50BxilYRCXuTKgufvo5Q==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-o4cRrxbMrKWsfep3XzBasv9OXAe42tIwnOVFlqgMHDMuA5MJLvzSowgnF58aHZGPxm3nXwk03o/SA0l9MkIiYg==";
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

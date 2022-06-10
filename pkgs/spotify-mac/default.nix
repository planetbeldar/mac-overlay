{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.87.612.gf8d110e2-18";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "2706gwngkimj0ni04cfqh0jf50d011i375qgrf9ndy5n8728rqkm9h2wnbs8brr96j8y74bkink7pp6zpnv7z92lh24jdzrvhy3jyy2";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "0mh8ga8z9nqc01c2ivihv1n9rahvjvkhv3x1n9qg9lc5qn4jlbqbnax3cjilfbapcixfg87ibj0y9g0kv162kya716k76jpwdn51qy6";
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

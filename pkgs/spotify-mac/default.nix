{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.89.862.g94554d24-16";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "105pcygn8pygkrglfcm3wbb1zi6r17krsypd6r4qrgb9f04yyf3fnpjyaz2jxc0ck78qx7q5xkn4wizv72rnxmy7qpw9pkj7swg8x78";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "2ly45ik0j0i3vgmxjxfdis2s4cv3nh1iaicsa184phl98nvghzarshqz1w4aj9hbvz9gli9ycg3gx3q9sg733wr19agp1hgv9lywf1v";
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

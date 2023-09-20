{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.20.1216.ge7a7b92f-1165";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-tgqGBuqvx4sn2/nBchvgtzRfHxTJBZkrF9Xsagb62Sc4R7QdowqccFB9ggfeMlClwkuxrK6GxtBqGB38ugK2bQ==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-om9fSp81QST6LaBKyNXqbPI8qKRF39+MDRyh8jZ0dkb2gaeRPC/1+GveYDCohJJsGRWidnYaTQ3BV968eRdUkA==";
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

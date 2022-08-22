{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.91.824.g07f1e963-9";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "3w8figfq578fainrahi3xqxkps6lkpv3kj8i7x1s9a7fgsnv1qpi6k2cvzssq1nkawjp90vfvp4mwzhm09ddaphz3vpc9hz61k6z2a8";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "08704avbnf7pi1fd79xyw1glgi6ndy44gybaqyiy0h0lrl1djcbj5982ssyspd5fg66aqzkzqzvip0vr35hx9njd5kiar0pr5g02gil";
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

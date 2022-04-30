{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.84.716.gc5f8b819-8";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "3dwfxx4g9xdir3ykgg0cfkaq4cx12kcmsimiz69588dmxmzmc4sxzihfxfhzzpmbp91bjn3c1v9h80jg2fri04b3yiy7x9v8lxjnfz3";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "1v1bfgdhi7r157wgf21xcngd14x6y9l9rxk3jzc7clqvc8m8xwavii7yk0rjj6mm93j21w03vml8ncx0nw8nc5c8iyy18sas4skdjv7";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl src;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.spotify.com";
    license = lib.licenses.unfree;
  };
}

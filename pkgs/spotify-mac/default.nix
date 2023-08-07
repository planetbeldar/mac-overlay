{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.17.834.g26ee1129-640";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-S6bgnT/WjhzqU314+Z5nWiEyu6fUfhe4ie1wIDb1nIdj3/hS6ib1JjPZH7Kp9fv4C8FyFMGqBeX/FI+bCR3DHg==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-gP6U1x3dkR6kjH9A7+swweUYlTsChZkb8NVUn+qaF7k0clvTzHwePLS0KHxqTyNgXHKda+bC+WeATx2Be0zHIg==";
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

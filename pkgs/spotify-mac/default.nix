{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.79.427";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-MOhKMhMzfQSHPXuP6PDoCTKi3Q04EKsCjRs+8+52D31Hk1F6i+gkJM/AbuIVhn8JkGNF+nWpO0NpWzSG58kT6A==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-6WM2cJaxQtdIjwhr3dfb3hD77qoyr9Kfqifc0LVJqfoz0Q5InFzbeWUwC0xOMZcfF7LpxMKo3I9K27omDjsJNQ==";
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

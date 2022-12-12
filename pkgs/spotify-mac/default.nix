{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.0.1165.gabf054ab-1083";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-AV8StFW99pFT97I6hGKfD6eIx6Dotr1khO8+Ys1TVl/ry02lkCgx0raX2rcX/qC/iGXK2JcmL/NMeZNbhEcweQ==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-H7sWpfXdQiubf6d3tb3gb+kDbxig7PM9kBlcKT7mdWbdQDOR7juUjYwIWLXxozGeoVp7kVe9ghRuiY+MPTGuyQ==";
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

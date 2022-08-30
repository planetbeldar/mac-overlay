{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.92.647.ga4397eb7-7";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "07j2c81n65nnxg4jpp80r5lx5m9bxrsl2gskg0h0csvk5s8ni83qap9ibjal9gyvpy8xlzfbj25f56jxgc0gc0kbmqrlw3xkigqps78";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "1bib87y801gg93llkbcks40mnsvganrj5fpgd4ikiiwj3mxx4vdy5ay9mxdql4ab7bwnmw1p8qivpjb7g7i9dr4m4jbd7a7cj9aa1df";
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

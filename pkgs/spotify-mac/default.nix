{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.22.982.g794acc0a-911";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-WffEPBEuxjSAjO55xETFefssZSMg5AvW7FoFOKWpyoMiFStZzKeFgAnJfkq6ZwqfiBQRjktzRIpS2YM//6HCDQ==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-1BaRLRFit1jNioTu3VRdjhhiWUs+ruoQBJb5lK3CValdNB59f9oUow1a8c4MbX1/4BymBQxg7CnsOuiwfxJ4NQ==";
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

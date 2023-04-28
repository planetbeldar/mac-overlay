{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.10.760.g52970952-1108";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-3ZXzneveuExml8U1cwoIZGcwjPcMEbILeU/6IbxZVIYpus//0zo7CS6v1H/krY0bpdynEsF82Job0ymGWI82LA==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-Lx9B/bLLxE45bLlutBhUYqsV3JSEyAgG9vSvJPONL/xS9K3eEeku1CAtbzeTTT7sS7Zzawi/PqyyDoNnJewjrQ==";
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

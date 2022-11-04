{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.97.962.g24733a46-812";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-MqL/r2ErHXFl5LRAbXGcn3POv4DsdMTL1qhgKAQhx0ynWpMzg6A/j0AlMQMyPUz2dvg/6gDn9O7XjrVQbr0ePw==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-Dx6IHiLc+jF/gx9vDGwbHVZpVPtiDJsvMtaJ9Ex91ZUNLsccCNEs0cNAxdTdNXnGvn5TFCH7oAUrgBRcbqzw7w==";
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

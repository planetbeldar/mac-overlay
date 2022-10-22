{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.96.785.g464c973a-1288";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-U+JHwrarFfI5AFnY6F3srH+VCFs9JwSDI2RqjnAZJrkMwFMXqbjAw8YmZsItRCLAWaTz5ld76iSzExxlJT2mSA==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-cFB5qa7hZvlA1XglselovaX9jDPeCpFuPrFMvDw/dDlljGPsWh0EoenZv3Fxge84yT/ko+XDnILDNSzfmTHpSA==";
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

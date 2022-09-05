{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.93.896.g3ae3b4f3-10";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-x9F4Wk/T+79Q3QgWYlc+wPVN946r3LTcw0PUc87oF1Cow62lV9jrvW79SVJTKEGIKo1bjPMPIt/SVXcVVpQuvA==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-X7e6DNgotcZXzU/ym/QC2f5CzfEJT7MpPSNftWiJcSG7PyfE9R+en5v1JPhTPyqrcI97x/EF7Q/wlDDNgwkVcQ==";
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

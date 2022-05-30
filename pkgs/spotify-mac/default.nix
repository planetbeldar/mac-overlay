{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.86.857.g3751ee08-41";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "2rsy3aps7abwx2mxrl6amysif42l69cpgldm9gnyvycxggmw9pp9srs80y0xa98bd0mjr6dgrxdffh7c5296w782gwpk15y9i9c0bml";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "0k6xxd8aicybii5dl62d2wybydmd1axf8w82djybz155dhcmyvmf4q6030yn8xh1cwzmm8qhd67msnpqp7awvz8x1h06s0za72q4r5q";
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

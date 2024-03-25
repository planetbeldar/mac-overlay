{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.33.1042.g26c92729-4440";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-y6WpdNM49G1J+08G9OQgsczqueLCc5PClwcm1Z6P9yapl33K5g38ikmiWB0SKTKc8XRPbaGKcmnlPd/AkiYefw==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-LZuUaEQdecMCfCGlvrkX3Fw1f8yAhL9ccxB5FhTBlOyYzsE9DfKcqTrD7TGrD0i87Ee/Rb4b04UnXSNYmhjSnQ==";
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

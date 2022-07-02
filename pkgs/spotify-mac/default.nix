{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.88.612.gcc529952-10";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "16h34n9wjps226jrxirm17aq8l8w60sxs2vw2ncg4dczkfy0dfp80888gslga0v03h0khr06vcz0klzfik4r66zci86pl2kl32q6qj4";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "10qrcg14lvlm64la41vg8i35mc8h01znpmjc1qfmggr1w7bx40d1fl1w1sdm0mma5z4pk11mdkxy5xv6wvncl4f9w0piwqhxxaixcvz";
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

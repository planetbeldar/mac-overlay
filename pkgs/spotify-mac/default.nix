{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.85.895.g2a71e1b8-31";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "3nmi1y9wj0cg67dyg7r925fz4qa8mlvbf0z88fx64scqn9vawy0js96bm3hfc34qxmgcbk06glx1f9x2k2iqs57yg24q29sssvckrd2";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "0qdpknqi75x2nmd8j2w4ycar6hb0s3qps6lddclyk77ihrh32n21mj07hxwk4nwiwf97nplsv61rsz5dshf04xwjxmk5m0wyihgrix6";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl src;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.spotify.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.3.1115.gd61a8f5c-384";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-RFPS+l0nON8aZa//K+KOiED91sif4CZnVkJ5Ao2xRX2vru7phBq6eX6Q+vaAOXm9ocLCxZ+ktTOWOomtPX/IXg==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-E8REcCBQfWVKDyq/wHGQ64ivqAWoH7AuXOy9U6BEPXs/o9sAaECQ3zbmXycsCOyLIRaean1MfUK/dgj4Xs6vOA==";
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

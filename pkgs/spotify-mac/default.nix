{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.5.1006.g22820f93-1069";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-bOP9PHVowWP83vmg5r3XxthpbAfvZhGLEUgULztfpDCJ5IzVWyh33W0n5hP0ABv3GElmQ8XrlZy64OHvahEzWQ==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-Vdkscffc0g7fmgh5rdv/USXifdi2ED68R6ih0hIf5avzCM5cWnJ4GQcbFiJ6eHYLexIWz0+xtqt+31/mEho0qw==";
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

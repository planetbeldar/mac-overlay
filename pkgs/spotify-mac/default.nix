{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.2.39.578.g0ea3f38b-107";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "sha512-xTo0YobLmUBsH/uha07vU57lVaoaZFJ2OuRXBmi1gQbi7FBRlgPHprUaA7FGEngjRzvre+zSGtXMWUignJRTCQ==";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "sha512-R9qvyP+JVQyPkUrzU3QqJm7OVVsTAnvHdHhvM7UPF1X1XsalRZ79Ac2BWnsH3OWVXSNxcoclseRgb2JOk5dFdg==";
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

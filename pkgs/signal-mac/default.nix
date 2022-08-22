{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.55.0";

  sha512 = {
    x64 = "1v9jnsy008acbkryip5vn0i03l41d1iwsg4z1ppsdd85fxqb9ki8wqc1v444ggl5b4j230zdvcis6gkjkcar2ji0qyk46ia4k04y775";
    arm64 = "2djxsgwkciqqvflw9liy86gh9775krsapfvwxpi4jsa0kqmk8xbvab4v995niw2bmix8ayyxrhvvhmvq32r08sx2hg5giakazw5dbar";
  };

  hostSystem = stdenv.hostPlatform.system;
  platform = {
    x86_64-darwin = "x64";
    aarch64-darwin = "arm64";
  }.${hostSystem} or (throw "Unsupported system: ${hostSystem}");

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-${platform}-${version}.dmg";
    sha512 = sha512.${platform} or (throw "Missing hash for host system: ${hostSystem}");
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://signal.com";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    description = "Private, simple, and secure messenger";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.45.1";

  sha512 = {
    x64 = "279ph0zfmqabwqkkc7vhjvid15c21gm4dxdsmh8fl4i12c94nrbv2gb5chgbldlfz8wg3wjvh54j9glq2ylpzz7p9ghy08dxcim35wx";
    arm64 = "2aczhv19ljh5z9pva78iicchcbdfafkz84rqhrisj3sn7xys5v3i9ivvwgbbdswpnbgph5l9d58zryf2pnva4cgyr18wa36ydgswal2";
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

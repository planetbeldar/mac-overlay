{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.37.0";

  sha512 = {
    x64 = "0y1kwf9i5bhhz50j38d9f2v25503cjcad6as753j7fb127vk0ngzl49rmlgyb9fkvyn7y7vqq8clzbadnf4yk7r0d11d0660sd6gj7a";
    arm64 = "2garysp1myn9f5b4xz7jc20jxnxad5x0g08pxk3g0mibq9pi9kkhnm3njxj4hbz0vqds86k60sgrs7hf6pkybsfavz9fm1izc18cgab";
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
  };
}

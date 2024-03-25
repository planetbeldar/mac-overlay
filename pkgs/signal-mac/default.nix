{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "7.3.1";

  sha512 = {
    x64 = "2c8dsajmbgpdqgkg7xjwkmi8zkkvqw0mr7lnm7ck8dbc9m11v8hy685jqw6zzfl4q6i46nkkq39hi2bd16fa72mmx24m2j1xc6r1v77";
    arm64 = "1fqgnqwj90z9agfkmnr02zm7jpyf28x3awicxdlyjvrabgzl8gy84cjpvdw2h7bks9b5gk7q0aqskfqvrw4lis321mackmjrpmhvx5k";
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

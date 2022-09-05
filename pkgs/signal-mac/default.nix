{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.57.0";

  sha512 = {
    x64 = "1ip1yb8v0phk4c2yhhfqzp7nqjnw8m6mv7b6dq0zpr69waxsrwz870zgwrkwhwzqmlsbbbbx7l89g7mg5xrd83icdpl9grzqghvhq62";
    arm64 = "1bj50dajfhzymvmmlrh4dzg6x127fn9gyrsg002pjyaxdq60scxfb5sx6gsw7mbkv6281bfr9lh9p7bq41ijhbwmiq34p6962j89ir0";
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

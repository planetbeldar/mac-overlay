{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "6.3.0";

  sha512 = {
    x64 = "2038cvp2cx28nd9wlsildyfm0spv0h3kybp109ji57n4ry6m4k0vvrkngwbz8d896kpi9ck9vsfrl7w25ck7jp1sfljv0fwrn0p9yxb";
    arm64 = "3ps4iac1g9j485xqdj79sl0wlbibwn22dmm8n3grgrwh40y238rpx241lsi5q5sc59lzcgz2di4dkysk2b1zilfs4kgj3qyz56wqkav";
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

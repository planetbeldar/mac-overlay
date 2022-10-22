{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.62.0";

  sha512 = {
    x64 = "2d34w55qaf25pvwkif1npvcxn4ir8g0g0lh8zwq0bw7a1kl37m3g659lwv6hs2iwxrbjqhv93c2z35jf0ins8gwpgdk8syln2cilpdv";
    arm64 = "10mpff3qmrs86b7shbad4cyxfpnrj4imqwpf217fjgh8dwvxksw9nn2p9zjccxwnkqz0infi5f43h19gccd644hp906qyxaf08z3pz1";
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

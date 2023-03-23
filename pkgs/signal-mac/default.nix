{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "6.11.0";

  sha512 = {
    x64 = "1gn9ln146b8k1p7s71x8lfyyyyq4yiiiynd386f8b144x11w6ppmp98w2xcvqc1r70fmrma1w0g7896nix7mdwm4d98sfg9m0fvq8gi";
    arm64 = "04hf17n618cjzj1y0kcsqc0maa573yarfh703j3j11sq0cvhffm89g6zi8mqc76yg1dycdzxhw2xj7h6zfsqfkindmv2ds6zy5ps0rx";
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

{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.50.1";

  sha512 = {
    x64 = "1dyylb0dc3sckr8lkm92krk14yzwww91x1ic3bl9yf85njdv75fmcl359z0pxki3nwbaqs4qrzc7nbz3rziy349h1xa2b3py4sw4zlq";
    arm64 = "1x2wxd0n82pg9sdm9bcdlfl8b2i192j706lbfcbvfxpcn3b4h24wa7kz6c61w8xhgdd8pi8vjcmckqc2l6997g75v81f76xg7zsrp31";
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

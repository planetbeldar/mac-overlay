{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.44.1";

  sha512 = {
    x64 = "3m57dkjf2zpim2hwc804vivf00dz368qi5ipklj9377jlh9s9afw4y8f4ahzzq0i76faq5xr1h13zfaypbj0qicp3kjfhpwbrhl0p32";
    arm64 = "383vdam16h3l05kgw0shfjmax8ikkxzd8923npxp78fp7060qyfp7b2ajp1da89zi0mgmxyxpcgi9s9d3pj3j2i3i2q9pfn83lskl93";
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

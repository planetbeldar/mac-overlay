{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.42.0";

  sha512 = {
    x64 = "0blsa1yxxccv5v005xy0l2ryfris837i1nrw0j33q96zqycfnac6qc1y37xqfv9yy8wacrl71p98d19wvzsb17cldfi0cwb71zaq5kg";
    arm64 = "3dmpvcxp4sjcp32fjqfdgki6rwf7cs7fd624kcmpxk3f142dbvm7qmfi67zccwz93arqlxmgcic2sjr8visfrbky5r1qkfw3k49xkzf";
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

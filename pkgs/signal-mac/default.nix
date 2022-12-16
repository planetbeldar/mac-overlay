{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "6.1.0";

  sha512 = {
    x64 = "04qmvshk9xq2bg4rwrb5vb6cak1cmaj62lw6hjafyn3vrl0sm8ndry54svszafbl0my30ac6lsa2c4p284731zl3rzw3sl76s526kkx";
    arm64 = "3fp2x3s11yk2hnbggw8jpg29gfrvzbjvq2625ls4cmh4v1y6y0m439pjnrsvbclay6smb3hidjmjs56hfa7b1cmm6pyfm7v4jsrcl1g";
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

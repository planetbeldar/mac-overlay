{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "7.12.0";

  sha512 = {
    x64 = "2nf5qhbzwlnnknapvs1fs33dqymak8vf0lnwzpdgy91pz545cs918ijh6r07sjhy5akjbiynn9py7ss2xlhpqqd1sb4q1sgrhf45hsf";
    arm64 = "0s33gg3blr98bidf7db6gmzpvrvp7y3mqfimc5f05bn8qhfy1cik1114hcngg6d726b42cilq6bimx09zqj739vch6ns2aca2xmn5sg";
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

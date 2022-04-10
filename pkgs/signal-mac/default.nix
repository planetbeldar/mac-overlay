{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.38.0";

  sha512 = {
    x64 = "3pyl8dg2z17jrh1561bii9wg1q92d1lg8mq29qgy96pdpy9pfyz936432xim72n52l78mzrwzb1pxn67n35csi6xpx3yi060z9d2kwj";
    arm64 = "0l4rvfxw4z93pvj67xsgdpq6wkscgp5c3x8xawj2kfp5vxgkp5imv952kjw19vrmmaf2b5gd320mafws1krjq56r1qvi249b0dc5g21";
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
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.58.0";

  sha512 = {
    x64 = "12gggxcxws0xl3fz47ql3a9lasxp1k2h98kspn1vj6x0sjzkpr48a055wcgrlryws2d4an018cxv8qv2qc9666xj8s7m6r82hlk7xkj";
    arm64 = "3j3g84izg1426afnpkmjnb75dkdl11snbhllmc6l675rs2w6h9nini5vghvkz0698nsm215zqw8px2vydkk180jrn2ldiqa0b4qpv71";
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

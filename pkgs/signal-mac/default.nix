{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.39.0";

  sha512 = {
    x64 = "2b0y909hjhi2fra2sfwxa41vxyjvhr0y7qpsah5nv6gcwir6hqlfi1gqb2xyiaw8ynzn2m0zqw17kqb6y7cg75h2bs2g0wjmhkrg73k";
    arm64 = "19qbm7n2kmyhzzlv8jxv5pfxflcnpi5g8a43fz81vgr673n4hzvxsj5psmqzgfrld9hjdbbrg6yds54q7zhh6s3y8pz2nvyjf1pg31p";
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

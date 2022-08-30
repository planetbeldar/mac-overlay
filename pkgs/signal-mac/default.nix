{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.56.0";

  sha512 = {
    x64 = "3qmqax7pdj9l2klkqqryjzi6cc88cg9dqfbqfv3d8lbbyhg0mmpwic0dmmrdnkdxwzlmm6w80zn6vw7hw3v9rwa7wsjlr60vhp0hi9v";
    arm64 = "3j75qchr5iyfy5xd4i5pkfh95s84pim7z5dzarbhvmr8bzcikzkhiqdl1x1vyqm6vc4r79nw4sfz3xl2cl4nm1b5wyz3cgmbgb5yvnx";
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

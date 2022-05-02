{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.41.0";

  sha512 = {
    x64 = "3c2rsd80l090b5lrprrlm2g40cfllsjpdzvwwxcgy1q25knnl763xza2la18zvimb01ijgk62z027rrjql9ansfmg9fcn3lkfdbq448";
    arm64 = "15gnpqxkkasgkpqsa3snac4nxz4ywcgqdhk59nc49c958kg53vzwvkinf2xd87292j4rr5jzyqi4w6v9p80fpacljgwmdkbk27l8id0";
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

{
  lib,
  stdenv,
  fetchurl,
}:
let
  pname = "signal";
  version = "7.83.0";

in
stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-${version}.dmg";
    sha512 = "2E2pTfQpSIS4E+swNyVhgH09AsQ0kTOSs9ttcLuf6F9fra6TD5QBdxJBPxcWVp2gVFljN6ymSOiMezoxyZRNeA==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://signal.com";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    description = "Private, simple, and secure messenger";
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  inherit (import ./settings.nix) version;
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    sha256 = "5c498af19e30bb37d677a614f2c36c4e6284f89cf017413086828c082a062823";
  };

  meta = {
    homepage = "https://signal.com";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    description = "Private, simple, and secure messenger";
    license = lib.licenses.agpl3Only;
  };
}

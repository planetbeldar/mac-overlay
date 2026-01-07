{ lib, stdenv, fetchzip }:
let
  pname = "hammerspoon";
  version = "1.1.0";
  appName = "Hammerspoon.app";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    sha256 = "rfgG1xQk+uSrRPiOgMpJ9F6unmlhg6cfrTCHCal1NlE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${appName}
    cp -R . $out/Applications/${appName}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.hammerspoon.org";
    description = "A tool for powerful automation of macOS";
    license = lib.licenses.mit;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

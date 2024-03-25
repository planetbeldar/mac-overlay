{ lib, stdenv, fetchzip }:
let
  inherit (lib) licenses;

  pname = "qmk-toolbox";
  version = "0.3.1";
  appName = "QMK Toolbox.app";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/qmk/qmk_toolbox/releases/download/${version}/QMK.Toolbox.app.zip";
    sha256 = "p5m5OZZdizUXDmqeACffpkSa7wUY6dHipbmyFitBvwk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${appName}
    cp -R . $out/Applications/${appName}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://qmk.fm/";
    description = "A collection of flashing tools packaged into one app. It supports auto-detection and auto-flashing of firmware to keyboards.";
    license = licenses.mit;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

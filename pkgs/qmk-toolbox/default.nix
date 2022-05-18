{ lib, stdenv, fetchzip }:
let
  inherit (lib) licenses;

  pname = "qmk-toolbox";
  version = "0.2.2";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/qmk/qmk_toolbox/releases/download/${version}/QMK.Toolbox.app.zip";
    sha256 = "+kIX6qQbzxcfrxAvo6TPsum56T9ym9iQwpDxbMzvDJM=";
  };

  installPhase = ''
    mkdir -p $out/Applications/QMK\ Toolbox.app
    cp -R . $out/Applications/QMK\ Toolbox.app
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://qmk.fm/";
    description = "A collection of flashing tools packaged into one app. It supports auto-detection and auto-flashing of firmware to keyboards.";
    license = licenses.mit;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

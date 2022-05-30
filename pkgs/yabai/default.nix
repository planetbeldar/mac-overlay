{ lib, stdenv, fetchzip }:
let
  pname = "yabai";
  version = "4.0.1";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
    sha256 = "dQZw7Df69aSbcU9ot6f73H3VzZEgo2qpgUM6IJRxk60=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = ''
      A tiling window manager for macOS based on binary space partitioning
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    license = lib.licenses.mit;
  };
}

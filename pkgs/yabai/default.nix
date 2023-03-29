{ lib, stdenv, fetchzip }:
let
  pname = "yabai";
  version = "5.0.3";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
    sha256 = "dnUrdCbEN/M4RAr/GH3x10bfr2TUjuomxIUStFK7X9M=";
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

final: prev:
let
  mylib = import ./default.nix { inherit (final) pkgs; };
in {
  stdenv = prev.stdenv // {
    inherit (mylib) mkDmgDerivation;
  };

  lib = prev.lib // {
    inherit (mylib) mapFilterAttrs mapFilterAttrs' mkOverlay;
  };
}

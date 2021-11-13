final: prev:
let
  mylib = prev.callPackage ./default.nix { };
in {
  stdenv = prev.stdenv // {
    inherit (mylib) mkDmgDerivation;
  };

  lib = prev.lib // {
    inherit (mylib) mapFilterAttrs mapFilterAttrs' mkOverlay;
  };
}

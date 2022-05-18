{
  description = "QMK Toolbox";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      mkDerivation = system:
        let pkgs = import nixpkgs { inherit system; };
        in pkgs.callPackage ./default.nix { };
    in {
      overlay = final: prev:
        let qmk-toolbox = mkDerivation prev.system;
        in { inherit qmk-toolbox; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let qmk-toolbox = mkDerivation system;
      in {
        packages = { inherit qmk-toolbox; };
        defaultPackage = qmk-toolbox;
      });
}

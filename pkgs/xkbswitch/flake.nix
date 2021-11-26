{
  description = "xkbswitch for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = [ (import ../../lib/overlay.nix) ];
      mkDerivation = system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in pkgs.callPackage ./default.nix { };
    in {
      overlay = final: prev:
        let xkbswitch = mkDerivation prev.system;
        in { inherit xkbswitch; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let
        xkbswitch = mkDerivation system;
      in {
        packages = { inherit xkbswitch; };
        defaultPackage = xkbswitch;
      });
}

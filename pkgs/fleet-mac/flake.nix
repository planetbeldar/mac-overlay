{
  description = "JetBrains Fleet for macOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = [ (import ../../lib/overlay.nix) ];
      mkDerivation = system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in pkgs.callPackage ./default.nix { };
    in {
      overlay = final: prev:
        let fleet-mac = mkDerivation prev.system;
        in { inherit fleet-mac; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let fleet-mac = mkDerivation system;
      in {
        packages = { inherit fleet-mac; };
        defaultPackage = fleet-mac;
      });
}

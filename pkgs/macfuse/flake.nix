{
  description = "MacFUSE";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = [ (import ../../lib/overlay.nix) ];
      mkDerivation = system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in pkgs.callPackage ./default.nix {
          inherit (pkgs.darwin.apple_sdk.frameworks) DiskArbitration;
        };
    in {
      overlay = final: prev:
        let macfuse = mkDerivation prev.system;
        in { inherit macfuse; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let macfuse = mkDerivation system;
      in {
        packages = { inherit macfuse; };
        defaultPackage = macfuse;
      });
}

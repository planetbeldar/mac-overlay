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
      mkPkgs = system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      mkDerivation = pkgs:
        import ./default.nix { inherit (pkgs) lib stdenv fetchFromGitHub clang darwin; };
    in {
      overlay = final: prev:
        let pkgs = mkPkgs prev.system;
        in { xkbswitch-mac = mkDerivation; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let
        pkgs = mkPkgs system;
        xkbswitch-mac = mkDerivation pkgs;
      in {
        packages = { inherit xkbswitch-mac; };
        defaultPackage = xkbswitch-mac;
      });
}

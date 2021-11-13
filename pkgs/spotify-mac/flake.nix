{
  description = "Spotify for macOS";

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
        import ./default.nix { inherit (pkgs) lib stdenv fetchurl; };
    in {
      overlay = final: prev:
        let pkgs = mkPkgs prev.system;
        in { spotify-mac = mkDerivation; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let
        pkgs = mkPkgs system;
        spotify-mac = mkDerivation pkgs;
      in {
        packages = { inherit spotify-mac; };
        defaultPackage = spotify-mac;
      });
}

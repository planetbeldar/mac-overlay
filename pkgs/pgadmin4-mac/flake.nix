{
  description = "pgAdmin4 for macOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = [ (import ../../lib/overlay.nix) ];
      mkDerivation = system:
        let
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        in pkgs.callPackage ./default.nix { };
    in {
      overlay = final: prev:
        let pgadmin4-mac = mkDerivation prev.system;
        in { inherit pgadmin4-mac; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let pgadmin4-mac = mkDerivation system;
      in {
        packages = { inherit pgadmin4-mac; };
        defaultPackage = pgadmin4-mac;
      });
}

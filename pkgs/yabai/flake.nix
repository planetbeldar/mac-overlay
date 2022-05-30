{
  description = "Yabai WM";

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
        let yabai = mkDerivation prev.system;
        in { inherit yabai; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let yabai = mkDerivation system;
      in {
        packages = { inherit yabai; };
        defaultPackage = yabai;
      });
}

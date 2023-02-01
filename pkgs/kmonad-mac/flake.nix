{
  description = "KMonad for mac, including Karabiner DriverKit Virtual HID Device";

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
        let kmonad = mkDerivation prev.system;
        in { inherit kmonad; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let kmonad = mkDerivation system;
      in {
        packages = { inherit kmonad; };
        defaultPackage = kmonad;
      });
}

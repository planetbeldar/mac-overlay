{
  description = "macOS overlay";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      inherit (builtins) mapAttrs readDir;
      inherit (flake-utils.lib) eachSystem system;

      mkDerivation = system: packageName:
        let
          overlay = final: prev: {
            stdenv = prev.stdenv // {
              inherit (prev.callPackage ./lib/default.nix {}) mkDmgDerivation;
            };
          };
          overlays = [ overlay ];
          pkgs = import nixpkgs { inherit system overlays; };
        in pkgs.callPackage (./pkgs + "/${packageName}") { };
      mkOverlay = packageDirs:
        (final: prev:
          mapAttrs (packageName: _:
            mkDerivation prev.system packageName) packageDirs);

      packageDirs = readDir ./pkgs;
      overlay = mkOverlay packageDirs;
      overlays = mapAttrs (packageName: _: (mkOverlay { ${packageName} = "directory"; })) packageDirs;
      packages = system:
        mapAttrs (packageName: _: mkDerivation system packageName) packageDirs;
      modules = mapAttrs (moduleName: _: import (./modules/services + "/${moduleName}")) (readDir ./modules/services);
    in {
      inherit overlay overlays modules;
    } // eachSystem [ system.x86_64-darwin system.aarch64-darwin ]
    (system: { packages = packages system; });
}

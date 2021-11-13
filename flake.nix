{
  description = "macOS packages and overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      overlays = [ (import ./lib/overlay.nix) ];
      mkPkgs = system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

      packageDirs = builtins.readDir ./pkgs;
      # mkPackages = pkgs:
      #   builtins.mapAttrs (n: v: (pkgs.callPackage (./pkgs + "/${n}") { }));
      mkPackages = pkgs:
        builtins.foldl'
        (res: p: res // { ${p} = pkgs.callPackage (./pkgs + "/${p}") { }; })
        { };
    in {
      overlay = final: prev:
        let
          pkgs = mkPkgs prev.system;
          packages = mkPackages pkgs (builtins.attrNames packageDirs);
        in packages;

      overlays = builtins.mapAttrs (n: v:
        (final: prev:
          let
            pkgs = mkPkgs prev.system;
            package = mkPackages pkgs [ n ];
          in package)) packageDirs;

    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let pkgs = mkPkgs system;
      in { packages = mkPackages pkgs (builtins.attrNames packageDirs); });
}

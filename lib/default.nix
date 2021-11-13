{ lib, stdenv, undmg }:
let
  inherit (lib) filterAttrs mapAttrs mapAttrs' elem attrNames trace;
  mkDmgDerivation = { pname, version, src, meta ? { } }:
    stdenv.mkDerivation {
      inherit version pname src;

      phases = [ "unpackPhase" "installPhase" ];

      nativeBuildInputs = [ undmg ];

      unpackPhase = ''
        ${undmg.out}/bin/undmg $src
      '';

      installPhase = ''
        mkdir -p $out/Applications
        cp -R *.app $out/Applications
      '';

      meta = meta // { platforms = lib.platforms.darwin; };
    };

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> newValue)
  #   set
  mapFilterAttrs = pred: f: set: mapAttrs f (filterAttrs pred set);

  # mapFilterAttrs' ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   set
  mapFilterAttrs' = pred: f: set: mapAttrs' f (filterAttrs pred set);

  # internal
  mkPkgs = pkgs: system: import pkgs { inherit system; };

  mapDerivationDirs = path:
    mapFilterAttrs
      (n: v: v == "directory")
      (n: v: path + "/${n}")
      (builtins.readDir path);

  # mkOverlay ::
  #   ({ name: path })
  # (final -> prev -> { name: derivation })
  mkOverlay = derivationDirs:
    (final: prev:
      let pkgs = mkPkgs prev.legacyPackages.${prev.system} prev.system;
      in with pkgs; lib.mapAttrs (n: v: (callPackage v { })));

  # mkOverlays = derivationDirs:

in {
  inherit
    mkDmgDerivation
    mapFilterAttrs
    mapFilterAttrs'
    mkOverlay;
}

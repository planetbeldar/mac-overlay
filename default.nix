let flake = builtins.getFlake (toString ./.);
    pkgs = import <nixpkgs> { overlays = [ flake.outputs.overlay]; };
in pkgs

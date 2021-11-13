{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let overlay = import ./overlay.nix;
    in {
      inherit overlay;
    };
  # flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ] (system:
  #   let
  #     pkgs = nixpkgs.legacyPackages.${system};
  #     # mylib = import ./default.nix { inherit pkgs; };
  #     overlay = import ./overlay.nix { inherit pkgs; };
  #   in {
  #     overlays = [ overlay ];
  #   });
}

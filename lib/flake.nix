{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let overlay = import ./overlay.nix;
    in {
      inherit overlay;
    };
}

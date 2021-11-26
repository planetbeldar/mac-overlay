{
  description = "Emacs 28 for macOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    emacs-src = {
      # no evaluation allowd here, cannot set branch dynamically (would like to use generated settings.nix)
      url = "github:emacs-mirror/emacs/emacs-28";
      flake = false;
    };

    emacs-vterm-src = {
      url = "github:akermu/emacs-libvterm";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, emacs-src, emacs-vterm-src, flake-utils }:
    let
      mkDerivation = system:
        let pkgs = import nixpkgs { inherit system; };
        in pkgs.callPackage ./default.nix {
          inherit emacs-src emacs-vterm-src;
        };
    in {
      overlay = final: prev:
        let emacs-mac = mkDerivation prev.system;
        in { inherit emacs-mac; };
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let emacs-mac = mkDerivation system;
      in {
        packages = { inherit emacs-mac; };
        defaultPackage = emacs-mac;
      });
}

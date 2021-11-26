{
  description = "macOS overlay";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    alacritty-mac.url = "github:planetbeldar/mac-overlay?dir=pkgs/alacritty-mac";
    alacritty-mac.inputs.nixpkgs.follows = "nixpkgs";
    alacritty-mac.inputs.flake-utils.follows = "flake-utils";

    discord-mac.url = "github:planetbeldar/mac-overlay?dir=pkgs/discord-mac";
    discord-mac.inputs.nixpkgs.follows = "nixpkgs";
    discord-mac.inputs.flake-utils.follows = "flake-utils";

    emacs-mac.url = "github:planetbeldar/mac-overlay?dir=pkgs/emacs-mac";
    emacs-mac.inputs.nixpkgs.follows = "nixpkgs";
    emacs-mac.inputs.flake-utils.follows = "flake-utils";

    sonos-mac.url = "github:planetbeldar/mac-overlay?dir=pkgs/sonos-mac";
    sonos-mac.inputs.nixpkgs.follows = "nixpkgs";
    sonos-mac.inputs.flake-utils.follows = "flake-utils";

    spotify-mac.url = "github:planetbeldar/mac-overlay?dir=pkgs/spotify-mac";
    spotify-mac.inputs.nixpkgs.follows = "nixpkgs";
    spotify-mac.inputs.flake-utils.follows = "flake-utils";

    xkbswitch.url = "github:planetbeldar/mac-overlay?dir=pkgs/xkbswitch";
    xkbswitch.inputs.nixpkgs.follows = "nixpkgs";
    xkbswitch.inputs.flake-utils.follows = "flake-utils";

    yabai.url = "github:planetbeldar/mac-overlay?dir=pkgs/yabai";
    yabai.inputs.nixpkgs.follows = "nixpkgs";
    yabai.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      inherit (builtins) foldl' mapAttrs intersectAttrs;

      packageNames = [
        "alacritty-mac"
        "discord-mac"
        "emacs-mac"
        "sonos-mac"
        "spotify-mac"
        "xkbswitch"
        "yabai"
      ];
      packageDirs = foldl' (res: x: res // { ${x} = "directory"; }) { } packageNames;
      packageInputs = intersectAttrs packageDirs inputs;

      packages = system: mapAttrs (n: v: v.defaultPackage.${system}) packageInputs;
      overlays = mapAttrs (n: v: v.overlay) packageInputs;
      overlay = final: prev: packages prev.system;
    in {
      inherit overlays overlay;
    } // flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ]
    (system: { packages = packages system; });
}

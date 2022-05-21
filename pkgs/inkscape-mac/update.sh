#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts

set -eou pipefail

name="inkscape-mac"
version="$(curl -sIL 'https://inkscape.org/release' | grep -oP '(?<=location: /release/inkscape-)\d+\.\d+(.\d+)?(?=\/)')"
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using $version"

update-source-version "$name" "$version" --file=./pkgs/"$name"/default.nix

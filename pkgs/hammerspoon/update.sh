#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts

set -eou pipefail

name="hammerspoon"
version=$(curl -sL https://api.github.com/repos/hammerspoon/hammerspoon/releases/latest | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo Using version "$version"

update-source-version "$name" "$version" --file=./pkgs/"$name"/default.nix

#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused common-updater-scripts

set -eou pipefail

name="yabai"
version=$(curl -s https://api.github.com/repos/koekeishiya/yabai/releases/latest | jq -r '.tag_name' | sed -e 's/^v//')
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo Using version "$version"

update-source-version "$name" "$version" --file=./pkgs/"$name"/default.nix

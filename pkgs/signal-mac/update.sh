#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq-go gnused common-updater-scripts

set -eou pipefail

name="signal-mac"
latest_release=$(curl --silent https://updates.signal.org/desktop/latest-mac.yml)
version=$(yq '.version' <<< "$latest_release")
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using version $version"

update-source-version "$name" "$version" --file=./pkgs/"$name"/default.nix

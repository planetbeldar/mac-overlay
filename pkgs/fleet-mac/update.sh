#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused common-updater-scripts

set -eou pipefail

name="fleet-mac"
latest_release=$(curl --silent 'https://data.services.jetbrains.com/products/releases?code=FL&latest=true&type=preview')
version=$(jq '.FL[].version' <<< "$latest_release" | tr -d '"')
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using version $version"

platforms=( \
  "x86_64-darwin  x64" \
  "aarch64-darwin aarch64" \
)
for kv in "${platforms[@]}"; do
  nix_platform=${kv%% *}
  platform=${kv##* }

  sha256_file=$(curl -s "$(jq .FL[].downloads.macos_"$platform".checksumLink <<< "$latest_release" | tr -d '"')")
  sha256=${sha256_file%% *}

  update-source-version "$name" 0 "0000000000000000000000000000000000000000000000000000" --system="$nix_platform" --file=./pkgs/"$name"/default.nix
  update-source-version "$name" "$version" "$sha256" --system="$nix_platform" --file=./pkgs/"$name"/default.nix
done

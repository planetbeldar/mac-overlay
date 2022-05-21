#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts

set -eou pipefail

url () {
  local version=${1}
  local platform=${2}

  echo "https://media.inkscape.org/dl/resources/file/Inkscape-${version}_${platform}.dmg"
}

name="inkscape-mac"
version="$(curl -sIL 'https://inkscape.org/release' | grep -oP '(?<=location: /release/inkscape-)\d+\.\d+(.\d+)?(?=\/)')"
version=$([[ "$version" =~ ^[0-9]+\.[0-9]+$ ]] && echo "$version.0" || echo "$version") # add patch part to version
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using $version"

platforms=( \
  "x86_64-darwin  x86_64" \
  "aarch64-darwin arm64" \
)
for kv in "${platforms[@]}"; do
  nix_platform=${kv%% *}
  platform=${kv##* }
  file_url=$(url "$version" "$platform")

  sha512=$(nix-prefetch-url --type sha512 "$file_url")

  update-source-version "$name" 0 "0000000000000000000000000000000000000000000000000000" --system="$nix_platform" --file=./pkgs/"$name"/default.nix
  update-source-version "$name" "$version" "$sha512" --system="$nix_platform" --file=./pkgs/"$name"/default.nix
done

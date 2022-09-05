#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl mktemp undmg xmlstarlet common-updater-scripts

set -eou pipefail

url () {
  local platform=${1:-}
  echo "https://download.scdn.co/Spotify${platform}.dmg"
}

temp_dir=$(mktemp -d)
pushd "$temp_dir"
trap "rm -fr $temp_dir" EXIT

curl "$(url)" --output Spotify.dmg
undmg Spotify.dmg
version=$(xmlstarlet sel --net -t -m "/plist/dict/key[.='CFBundleVersion']" -v "following-sibling::string[1]" ./Spotify.app/Contents/Info.plist)
popd

name="spotify-mac"
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')
if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using version $version"

platforms=( \
  "x86_64-darwin   " \
  "aarch64-darwin  ARM64" \
)
for kv in "${platforms[@]}"; do
  nix_platform=${kv%% *}
  platform=${kv##* }
  file_url=$(url "$platform")

  sha512=$(nix hash to-sri --type sha512 "$(nix-prefetch-url --type sha512 "$file_url")")

  update-source-version "$name" 0 "0000000000000000000000000000000000000000000000000000" --system="$nix_platform" --file=./pkgs/"$name"/default.nix
  update-source-version "$name" "$version" "$sha512" --system="$nix_platform" --file=./pkgs/"$name"/default.nix
done

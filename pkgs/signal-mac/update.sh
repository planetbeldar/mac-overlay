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

echo Using version "$version"

platforms=( \
  "x86_64-darwin   x64" \
  "aarch64-darwin  arm64" \
)
for kv in "${platforms[@]}"; do
  nix_platform=${kv%% *}
  platform=${kv##* }

  sha512=$(nix-prefetch-url --type sha512 "https://updates.signal.org/desktop/signal-desktop-mac-$platform-$version.dmg")
  update-source-version signal-mac 0 "0000000000000000000000000000000000000000000000000000" --system="$nix_platform" --file=./pkgs/signal-mac/default.nix
  update-source-version signal-mac "$version" "$sha512" --system="$nix_platform" --file=./pkgs/signal-mac/default.nix
done

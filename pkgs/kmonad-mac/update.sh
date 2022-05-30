#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eou pipefail

name="kmonad-mac"
commit=$(curl -s 'https://api.github.com/repos/kmonad/kmonad/commits/master')
rev=$(jq -r '.sha' <<< "$commit")
version=$(jq -r '.commit.committer.date[:10]' <<< "$commit")
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using version $version"

update-source-version "$name" "$version" --rev="$rev" --file=./pkgs/"$name"/default.nix

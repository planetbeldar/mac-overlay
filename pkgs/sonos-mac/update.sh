#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl mktemp undmg xmlstarlet common-updater-scripts

set -eou pipefail

temp_dir=$(mktemp -d)
pushd "$temp_dir"
trap "rm -fr $temp_dir" EXIT

curl -L "https://www.sonos.com/en/redir/controller_software_mac2" -O
undmg controller_software_mac2
shortBundleVersion=$(xmlstarlet sel --net -t -m "/plist/dict/key[.='CFBundleShortVersionString']" -v "following-sibling::string[1]" ./Sonos.app/Contents/Info.plist)
bundleVersion=$(xmlstarlet sel --net -t -m "/plist/dict/key[.='CFBundleVersion']" -v "following-sibling::string[1]" ./Sonos.app/Contents/Info.plist)
version="$shortBundleVersion,$bundleVersion"
popd

name="sonos-mac"
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')
if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using version $version"

update-source-version "$name" "$version" --file=./pkgs/"$name"/default.nix

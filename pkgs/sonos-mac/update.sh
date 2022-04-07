#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wget mktemp undmg xmlstarlet common-updater-scripts

set -eou pipefail

temp_dir=$(mktemp -d)
pushd "$temp_dir"
trap "rm -fr $temp_dir" EXIT

wget "https://www.sonos.com/en/redir/controller_software_mac2"
undmg controller_software_mac2
version=$(xmlstarlet sel --net -t -m "/plist/dict/key[.='CFBundleShortVersionString']" -v "following-sibling::string[1]" ./Sonos.app/Contents/Info.plist)

popd
echo Using version "$version"

update-source-version sonos-mac "$version" --file=./pkgs/sonos-mac/default.nix

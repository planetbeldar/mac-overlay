#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts

set -eou pipefail

name="discord-mac"
version="$(curl -sI 'https://discord.com/api/download/stable?platform=osx' | grep -oP '(?<=location: https:\/\/dl\.discordapp\.net\/apps\/osx\/)\d+\.\d+\.\d+(?=\/Discord\.dmg)')"
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')

if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $currentVersion"
  exit 0
fi

echo "Using $version"


update-source-version discord-mac "$version" --file=./pkgs/discord-mac/default.nix

#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts

set -eou pipefail
version="$(curl -sI 'https://discord.com/api/download/stable?platform=osx' | grep -oP '(?<=location: https:\/\/dl\.discordapp\.net\/apps\/osx\/)\d+\.\d+\.\d+(?=\/Discord\.dmg)')"

echo "using $version"

update-source-version discord-mac "$version" --file=./pkgs/discord-mac/default.nix

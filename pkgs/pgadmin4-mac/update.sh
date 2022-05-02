#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts

tags=$(curl -sSL 'https://ftp.postgresql.org/pub/pgadmin/pgadmin4')
versions=$(sed -rne 's,^<a href="v([0-9]+\.[0-9]+)/">.*,\1,p' <<< "$tags")
version=$(echo "$versions" | sort | tail -n 1)

name="pgadmin4-mac"
currentVersion=$(nix-instantiate --eval -E "with import ./.; $name.version" | tr -d '"')
if [[ "$version" == "$currentVersion" ]]; then
  echo "$name is up to date: $version"
  exit 0
fi

echo "Using version $version"

update-source-version "$name" "$version" --file=./pkgs/$name/default.nix

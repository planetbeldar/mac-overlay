#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl gnused common-updater-scripts

versionPattern='.*emacs-([0-9.]+)-mac-([0-9.]+).*'
macNews=$(curl --silent https://bitbucket.org/mituharu/emacs-mac/raw/master/NEWS-mac)

emacsVersion=$(sed -En "0,/$versionPattern/s/$versionPattern/\1/p" <<< $macNews)
macportVersion=$(sed -En "0,/$versionPattern/s/$versionPattern/\2/p" <<< $macNews)

echo "Using version $emacsVersion-mac-$macportVersion"

update-source-version emacs-mac "$emacsVersion" "0000000000000000000000000000000000000000000000000000" --file=./pkgs/emacs-mac/default.nix
update-source-version emacs-mac "$macportVersion" --version-key="macportVersion" --file=./pkgs/emacs-mac/default.nix

#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl yq-go nix-prefetch

latest_release=$(curl --silent https://updates.signal.org/desktop/latest-mac.yml)
version=$(yq e '.version' - <<< "$latest_release")

dirname=$(dirname "$0")
output_settings="$dirname/settings.nix"

echo Using version "$version"

warning=$'### Generated by update script.\n'
printf '''%s
{
  version = \"%s\";
  sha512 = {
''' "$warning" "$version" > $output_settings
# printf '%s{\n  version = \"%s\";\n}\n' "$warning" "$version" > $output_settings

platforms=(x64 arm64)
for platform in "${platforms[@]}"; do
  sha512=$(nix-prefetch-url --type sha512 "https://updates.signal.org/desktop/signal-desktop-mac-$platform-$version.dmg")
  printf "    %s = \"%s\";\n" "$platform" "$sha512" >> $output_settings
done

printf "  };\n}\n" >> $output_settings

{ lib, stdenv, fetchurl }:
let
  inherit (lib.lists) take last;
  inherit (lib.strings) splitString;
  inherit (builtins) concatStringsSep;

  pname = "sonos";
  version = "14.14,69.1.32100";

  # versions = splitString "," version;
  # fileVersion = let
  #   versionNumbers = splitString "." (last versions);
  # in "${concatStringsSep "." (take 2 versionNumbers)}-${last versionNumbers}";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # url = "https://update-software.sonos.com/software/flfowmpo/Sonos_${fileVersion}.dmg";
    # url changes with every release, use redirect url for now
    url = "https://www.sonos.com/en/redir/controller_software_mac2";
    sha512 = "eVHzehKIO0aGcQ6WPbNQeVxkim8w3w+vGZKJGBKXz0mfH1JzwciMadD4cu/GiMKqCz7lpM8j3VlboLTMW81Scg==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

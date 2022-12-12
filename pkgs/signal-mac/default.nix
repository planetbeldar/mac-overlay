{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "6.0.1";

  sha512 = {
    x64 = "3pdla1q5mv90ir1nwlfm61dqa3zcrm9gq574a2dm6kv78y921lplnpiagqvs55xq9d9za9ashl8hsyvm40dz2jg3fxf3in9gckqm8z5";
    arm64 = "3rk5d7a954qi80rnj0y14cbl0lpcsph0hyvvrcbs8yslnwr54rj4iwi45s5j93jf5lgmhwhn3xs53ph9iygpf54a5h4d5yk7mhyihha";
  };

  hostSystem = stdenv.hostPlatform.system;
  platform = {
    x86_64-darwin = "x64";
    aarch64-darwin = "arm64";
  }.${hostSystem} or (throw "Unsupported system: ${hostSystem}");

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-${platform}-${version}.dmg";
    sha512 = sha512.${platform} or (throw "Missing hash for host system: ${hostSystem}");
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://signal.com";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    description = "Private, simple, and secure messenger";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

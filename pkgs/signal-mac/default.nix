{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.46.0";

  sha512 = {
    x64 = "2h6xbw33w47p6njmglpp2ivaqrj512ivgnrasqg3s8isgnqm677z8y0lc3v5gzbd4kawm9a2ibh1n5wv04h8zn1zpk22ji5rpkjlf0i";
    arm64 = "24hc17a0bphaxw1n4rsdq3mr7sb8yqi1zc485112bv180khs610lnndpmzz77j4c21ah8zqbakn8csahiiq9gf6za3zbhwfyxfga6l7";
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

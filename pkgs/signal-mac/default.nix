{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.48.0";

  sha512 = {
    x64 = "27zcrf050kkq9xlxmmdl933n6ly4nmdsgldv5ni1aqqkpg5yxwyhdksv90cv2b63jjm1bazm5gvfmgcy8cgrgq009hja2mijg7qfkv8";
    arm64 = "13i1jnj7nzgkxrmxxpyjasby723a9s97vxd7234a45msxxwdy4y9mhsxrg3y54chq3lk58zmvw2s0dqbqcgnlvz46c6ivfj7h7m9adw";
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

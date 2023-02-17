{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "6.6.0";

  sha512 = {
    x64 = "3w9s543bzihvqwmlz8xjj7pyz5sbvclgc1zkscxqpvs6rk83h8521c6zhcp2h3g0yka2bzd67y4zda84z67ahyfb4ij6plnhfczh2v8";
    arm64 = "11vr9knb980gxy49cvi2zmba7jqns01wn7241whjnh7hbynmpc41hs86ghka1yfc405a65532yhm5x3w2anhdljvwcggf2gcr0p41x5";
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

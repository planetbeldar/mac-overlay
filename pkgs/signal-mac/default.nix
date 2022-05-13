{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.43.0";

  sha512 = {
    x64 = "1yaj3lx2mf4q5fzr0rv79q3gc73pfrq9fhxgjm62dhkpmjxlvhyy2dw9agcmxqz7bdl08sgijv021nyjbppj5gywb0rbl1174i3kczp";
    arm64 = "07rb6nkc1dl0ri0iz2ipdk5pnzwgb2xl5acvhl9m72qxg113yl9rygglhmm5smzq4k8zqlvn3ikx4244hvajpinj6iy0mrl52cziy06";
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

{ lib, stdenv, fetchurl }:
let
  pname = "signal";
  version = "5.60.0";

  sha512 = {
    x64 = "2202jriw6b57zq8m5043dvj62fwy4ys9x6rganws279qhnjnqhz59pjh903zs967w4h35kxsjqifirhd684q3312d76y61gbwbx2q9x";
    arm64 = "2rp1a0ssxcxl4cg16zzqc2x2a0h7psmi541yv4vnfncdh11m17pd4zjq5nqhgzq7bh5qk0i537pa2qyakmhs9gpsgsappxx9cc3zjk2";
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

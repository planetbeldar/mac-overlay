{ lib, stdenv, fetchurl }:
let
  pname = "sonos";
  version = "14.20";

in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    # Random url segment and filename with internal/build version numbers
    url = "https://update-software.sonos.com/software/qcpuqybt/Sonos_70.4-35282.dmg";
    sha512 = "sha512-O25c0k85q9d73HwIwvP1voHBAhW9BSLlsnL3wpG6jrnw7NuSGw3QoU0TsMnPH3Zzc1Ekt9+WestNSMsxgVjdlQ==";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.sonos.com";
    license = lib.licenses.unfree;
  };
}

{ lib, stdenv, fetchurl }:
let
  pname = "pgadmin4";
  version = "6.9";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/macos/pgadmin4-${version}.dmg";
    sha256 = "sKadgooUPXLOlY0/EnW5M7tQkGHg2+mNaQDaT5aNhRA=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.pgadmin.org";
    description = "Administration and development platform for PostgreSQL";
    license = lib.licenses.postgresql;
  };
}

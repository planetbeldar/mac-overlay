{ lib, stdenv, fetchurl }:
let
  pname = "pgadmin4";
  version = "6.7";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/macos/pgadmin4-${version}.dmg";
    sha256 = "39ccc32418c59334fc893d863427697f220f3f9ea8da04450cd65d90107db085";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.pgadmin.org";
    description = "Administration and development platform for PostgreSQL";
    license = lib.licenses.postgresql;
  };
}

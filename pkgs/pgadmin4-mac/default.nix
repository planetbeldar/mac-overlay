{ lib, stdenv, fetchurl }:
let
  pname = "pgadmin4";
  version = "7.6";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/macos/pgadmin4-${version}-x86_64.dmg";
    sha256 = "m3/ZWPDhY8MjdopeNwNMRfgpaPWxmuGplq79Pne/A0I=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.pgadmin.org";
    description = "Administration and development platform for PostgreSQL";
    license = lib.licenses.postgresql;
  };
}

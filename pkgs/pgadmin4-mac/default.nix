{ lib, stdenv, fetchurl }:
let
  pname = "pgadmin4";
  version = "8.4";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/macos/pgadmin4-${version}-x86_64.dmg";
    sha256 = "0G5SsGYcuugYJBH548VW1obuQmhRczyb2wGTCQmdtIk=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.pgadmin.org";
    description = "Administration and development platform for PostgreSQL";
    license = lib.licenses.postgresql;
  };
}

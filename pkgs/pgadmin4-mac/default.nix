{ lib, stdenv, fetchurl }:
let
  pname = "pgadmin4";
  version = "9.11";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/macos/pgadmin4-${version}-arm64.dmg";
    sha256 = "65XwYTEI8aWzqOwyM9p3BH+AQAZKdlUfeAwhMll06rU=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.pgadmin.org";
    description = "Administration and development platform for PostgreSQL";
    license = lib.licenses.postgresql;
  };
}

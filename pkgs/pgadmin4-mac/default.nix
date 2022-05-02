{ lib, stdenv, fetchurl }:
let
  pname = "pgadmin4";
  version = "6.8";
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${version}/macos/pgadmin4-${version}.dmg";
    sha256 = "DH/2t+0rhow7WRySxMwxJxSf/nbYX8hUZMG77KpqqeQ=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.pgadmin.org";
    description = "Administration and development platform for PostgreSQL";
    license = lib.licenses.postgresql;
  };
}

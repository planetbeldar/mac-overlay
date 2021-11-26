{ lib, stdenv, fetchFromGitHub, clang, darwin }:
let
  inherit (lib) platforms licenses;
  inherit (darwin.apple_sdk.frameworks) Foundation Carbon;

  pname = "xkbswitch";
  version = "67d53d60ebc840a617adfe9596d4998cb3eafd83";
in stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "myshov";
    repo = "xkbswitch-macosx";
    rev = version;
    sha256 = "1wnsqpd4d33d24r6f1j0x482af926kd7r5scikd7nzp72qmdz23y";
  };

  buildInputs = [ clang Foundation Carbon ];

  buildPhase = ''
    rm -fr bin
    mkdir -p bin
    ${clang.out}/bin/clang xkbswitch/main.m -std=c99 -Wall -DNDEBUG -O2 -fvisibility=hidden -mmacosx-version-min=10.6 -framework Foundation -framework Carbon -o bin/xkbswitch
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/${pname} $out/bin/${pname}
  '';

  meta = {
    homepage = "https://github.com/myshov/xkbswitch-macosx";
    description = "Console keyboard layout switcher for Mac OS X.";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}

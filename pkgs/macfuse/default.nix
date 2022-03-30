{ lib, stdenv, fetchurl, undmg, cpio, xar, DiskArbitration }:
let
  pname = "macfuse";
  version = "4.2.4";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/osxfuse/osxfuse/releases/download/macfuse-${version}/macfuse-${version}.dmg";
    sha256 = "82a2c30b3a7bf56aa2755c0c192fb50d9eecc3fe42505ab4e8679b50306188bd";
  };

  nativeBuildInputs = [ undmg cpio xar ];
  propagatedBuildInputs = [ DiskArbitration ];

  postUnpack = ''
    xar -xf 'Install macFUSE.pkg'
    cd Core.pkg
    gunzip -dc Payload | cpio -i
  '';

  sourceRoot = ".";
  dontConfigure = true;

  buildPhase = ''
    sed -i "s|^prefix=.*|prefix=$out|" usr/local/lib/pkgconfig/fuse.pc
  '';

  installPhase = ''
    mkdir -p $out/include $out/lib/pkgconfig
    cp usr/local/lib/*.dylib $out/lib
    cp usr/local/lib/pkgconfig/*.pc $out/lib/pkgconfig
    cp -R usr/local/include/* $out/include
  '';

  meta = {
    homepage = "https://osxfuse.github.io";
    changelog = "https://github.com/osxfuse/osxfuse/releases/tag/macfuse-${version}";
    description = "macFUSE allows you to extend macOS via third party file systems";
    # license = lib.licenses.?;
    platforms = lib.platforms.darwin;
  };
}

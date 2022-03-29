{ lib, stdenv, fetchFromGitHub, stack, libiconv, git, darwin, xar, gzip, cpio }:
let
  inherit (lib) licenses platforms;
  inherit (darwin.apple_sdk.frameworks) IOKit;

  pname = "kmonad";
  version = "0.4.1";

  extraIncludeDirs = "c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/include/pqrs/karabiner/driverkit:c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/src/Client/vendor/include";
  karabinerDir = "Karabiner-DriverKit-VirtualHIDDevice";
  # This package requires a few manual steps in MacOS
  # 1. enable input monitoring for launchctl (assuming you start kmonad via launchd) and kmonad (system settings)
  # 2. script needs install and activate virtual hid device to root (is this really necessary?)
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "kmonad";
    repo = "kmonad";
    fetchSubmodules = true;
    rev = "e5414dcc4c1a25ef10cccdf481accdad5605fe05";
    sha256 = "vnnUjz9av9bvOAkHRIuXYSs4Gqnyj+dEhrO1qADwy0M=";
  };

  buildInputs = [
    stack
    libiconv
    git
  ] ++ lib.optional stdenv.isDarwin [
    IOKit
    xar
    gzip
    cpio
  ];

  postUnpack = lib.optionalString stdenv.isDarwin ''
    mkdir $sourceRoot/${karabinerDir}
    pushd $sourceRoot/${karabinerDir}
    xar -xf ../c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/dist/Karabiner-DriverKit-VirtualHIDDevice-1.15.0.pkg
    cat Payload | gunzip -dc | cpio -i
    popd
  '';

  buildPhase = ''
    runHook preBuild
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir home
    export HOME=$PWD/home

    stack build \
      --flag kmonad:dext \
      --extra-include-dirs=${extraIncludeDirs} \
      --local-bin-path ./bin \
      --copy-bins
  '' + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/${pname} $out/bin
  '' + lib.optionalString stdenv.isDarwin ''
    cp -R ${karabinerDir}/{Applications,Library} $out/bin
  '' + ''
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/kmonad/kmonad";
    description = "KMonad is an advanced tool that lets you infinitely customize and extend the functionalities of almost any keyboard";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}

{ lib, stdenv, fetchFromGitHub, stack, libiconv, git, darwin, xar, gzip, cpio }:
let
  inherit (lib) licenses platforms;
  inherit (darwin.apple_sdk.frameworks) IOKit;

  pname = "kmonad";
  version = "2022-05-28";

  karabinerDir = "Karabiner-DriverKit-VirtualHIDDevice";
  # This package requires a few manual steps in MacOS
  # 1. enable input monitoring for launchctl (assuming you start kmonad via the included launchd service module) and kmonad (system settings)
  # 2. script needs install and activate virtual hid device to root (is this really necessary?)
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "kmonad";
    repo = "kmonad";
    fetchSubmodules = true;
    rev = "58267c854ae6fd6c4ef84f45d176fc4c6cce7d0f";
    sha256 = "znmFMXSby1uvANr2cm929RYX3pwu5/kEwwFYOV+aNyM=";
  };

  nativeBuildInputs = [ xar gzip cpio stack libiconv git ];

  buildInputs = lib.optional stdenv.isDarwin [
    IOKit
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
      --extra-include-dirs=c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/include/pqrs/karabiner/driverkit:c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/src/Client/vendor/include \
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
    cp -R ${karabinerDir}/{Applications,Library} $out
  '' + ''
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/kmonad/kmonad";
    description = "KMonad is an advanced tool that lets you infinitely customize and extend the functionalities of almost any keyboard";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}

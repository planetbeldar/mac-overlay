{ lib, stdenv, fetchFromGitHub, stack, libiconv, git, darwin, xar, gzip, cpio, llvm }:
let
  inherit (lib) licenses platforms;
  inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;

  pname = "kmonad";
  version = "2024-01-15";

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
    rev = "eea2585fbb3e36f4211b8e2bf0da5d42ec35050f";
    sha256 = "QKbW8eS3+vKHj7yfaR4/1l445AuPcBXhq29bezT4zYs=";
  };

  nativeBuildInputs = [ xar gzip cpio stack libiconv git llvm ];

  buildInputs = lib.optional stdenv.isDarwin [
    CoreFoundation
    IOKit
  ];

  postUnpack = lib.optionalString stdenv.isDarwin ''
    mkdir $sourceRoot/${karabinerDir}
    pushd $sourceRoot/${karabinerDir}
    xar -xf ../c_src/mac/${karabinerDir}/dist/Karabiner-DriverKit-VirtualHIDDevice-3.1.0.pkg
    cat Payload | gunzip -dc | cpio -i
    popd
  '';

  buildPhase = ''
    runHook preBuild
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p home
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

{ haskellPackages, lib, stdenv, darwin, fetchFromGitHub, xar, gzip, cpio }:
let
  inherit (lib) licenses platforms;
  inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;

  name = "kmonad";
  version = "2024-02-11";

  karabinerDir = "Karabiner-DriverKit-VirtualHIDDevice";
  src = fetchFromGitHub {
    owner = "kmonad";
    repo = "kmonad";
    rev = "70a5e97518c87ff52be4b403d774e88c5c61e3c1";
    sha256 = "oyq3hCFqQb5Yi28PCW5k1MJnSuGfdyqOqXYH2mcPK/8=";
    fetchSubmodules = true;
  };
  # make /usr/bin/security available for stack on darwin
  # security = writeScriptBin "security" ''exec /usr/bin/security "$@"'';

  # This package requires a few manual steps in MacOS
  # 1. enable input monitoring for launchctl (assuming you start kmonad via the included launchd service module) and kmonad (system settings)
  # 2. script needs install and activate virtual hid device to root (is this really necessary?)
in (
  haskellPackages.callCabal2nixWithOptions
    name
    src
    (lib.optionalString stdenv.isDarwin "--flag=dext")
    { }
).overrideAttrs (drv: {
  inherit version;

  configureFlags = drv.configureFlags ++ (lib.optionals stdenv.isDarwin [
    "--extra-include-dirs=c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/include/pqrs/karabiner/driverkit"
    "--extra-include-dirs=c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/src/Client/vendor/include"
  ]);

  buildInputs = drv.buildInputs ++ (lib.optionals stdenv.isDarwin [
    CoreFoundation IOKit
  ]);

  postUnpack = lib.optionalString stdenv.isDarwin ''
    mkdir $sourceRoot/${karabinerDir}
    pushd $sourceRoot/${karabinerDir}
    ${xar}/bin/xar -xf ../c_src/mac/${karabinerDir}/dist/Karabiner-DriverKit-VirtualHIDDevice-3.1.0.pkg
    cat Payload | ${gzip}/bin/gunzip -dc | ${cpio}/bin/cpio -i
    popd
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    cp -R ${karabinerDir}/{Applications,Library} $out
  '';

  passthru.updateScript = ./update.sh;
})

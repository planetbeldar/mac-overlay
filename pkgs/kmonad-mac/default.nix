{ haskellPackages, lib, stdenv, darwin, fetchFromGitHub, xar, gzip, cpio }:
let
  inherit (lib) licenses platforms;
  inherit (darwin.apple_sdk.frameworks) CoreFoundation IOKit;

  name = "kmonad";
  version = "2024-06-07";

  karabinerDir = "Karabiner-DriverKit-VirtualHIDDevice";
  src = fetchFromGitHub {
    owner = "kmonad";
    repo = "kmonad";
    rev = "235b42610758355a664c153999c1ff03b4d918e6";
    sha256 = "VcGu0i6/2PVFHmyrnLivxEARX2bcPLxgkSFoUYjx3YY=";
    fetchSubmodules = true;
  };

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

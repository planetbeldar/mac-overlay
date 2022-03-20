{ lib, yabai }:
let
  version = "4.0.0";
in yabai.overrideAttrs (drv: {
  inherit version;

  src = builtins.fetchTarball {
    url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
    sha256 = "1iwzan3mgayfkx7qbbij53hkxvr419b6kmypp7zmvph270yzy4r9";
  };
})

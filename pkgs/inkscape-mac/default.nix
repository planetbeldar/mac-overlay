{ lib, stdenv, fetchurl }:
let
  pname = "inkscape";
  version = "1.4.3";

  url = arch: "https://media.inkscape.org/dl/resources/file/Inkscape-${version}_${arch}.dmg";
  src = {
    x86_64-darwin = {
      url = url "x86_64";
      sha512 = "1j0ccxmny6kgy8jcmb5llv5ma4crqbvysjwik6y53g0vrhp6yi2cbj0407b32x0fs1m0d85gacs5zdc9z7b8rvgzcch2vp431mlgm95";
    };
    aarch64-darwin = {
      url = url "arm64";
      sha512 = "1nybvpirghp9h8x2nfknkm53aflahnbgfip3dvj00z12x96srck75sbhfydgj9w7b4gqn4nb4cxbbsx4bw9ckp0a0n1n7az3hz08kbx";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl src;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.inkscape.org";
    description = "Inkscape is a Free and open source vector graphics editor for GNU/Linux, Windows and MacOS X";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}

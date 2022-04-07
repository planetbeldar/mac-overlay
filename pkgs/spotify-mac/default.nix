{ lib, stdenv, fetchurl }:
let
  pname = "spotify";
  version = "1.1.81.604.gccacfc8c-16";

  src = {
    x86_64-darwin = {
      url = "https://download.scdn.co/Spotify.dmg";
      sha512 = "1dh0lc0dn12n5km119vjvfmfyn7c6w102xgjify138vbhhqxk2kcygpp8qnddb53gpp7mmhlw963x5wzksmmfbc1dr3i5cqblpgxad5";
    };
    aarch64-darwin = {
      url = "https://download.scdn.co/SpotifyARM64.dmg";
      sha512 = "1h0rz0gsqywdawpfkaifw8f7xygqh18kigfjczjxwqn2hb6gz80pxk9p0xz6wwm0mkzy6zlnk0byxlmbc3f24cq1mqgkr1v5z71zyss";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in stdenv.mkDmgDerivation {
  inherit pname version;

  src = fetchurl src;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.spotify.com";
    license = lib.licenses.unfree;
  };
}

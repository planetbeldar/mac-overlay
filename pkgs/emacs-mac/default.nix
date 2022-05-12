{ lib, stdenv, cmake, libtool, glib, libvterm-neovim, ncurses, darwin, emacs
, fetchFromGitHub, fetchFromBitbucket, writeText, ... }:
let
  inherit (builtins) filter elem;

  emacs-vterm = stdenv.mkDerivation rec {
    pname = "emacs-vterm";
    version = "master";

    src = fetchFromGitHub {
      owner = "akermu";
      repo = "emacs-libvterm";
      rev = "b44723552f86407d528c4a6c8057382c061b008e";
      sha256 = "A4ptIWzeF4oFzK8bptP1UxHNp296res20Ydt6vnUAmc=";
    };

    nativeBuildInputs = [ cmake libtool glib.dev ];

    buildInputs = [ glib.out libvterm-neovim ncurses ];

    cmakeFlags = [ "-DUSE_SYSTEM_LIBVTERM=yes" ];

    preConfigure = ''
      echo "include_directories(\"${glib.out}/lib/glib-2.0/include\")" >> CMakeLists.txt
      echo "include_directories(\"${glib.dev}/include/glib-2.0\")" >> CMakeLists.txt
      echo "include_directories(\"${ncurses.dev}/include\")" >> CMakeLists.txt
      echo "include_directories(\"${libvterm-neovim}/include\")" >> CMakeLists.txt
    '';

    installPhase = ''
      mkdir -p $out
      cp ../vterm-module.so $out
      cp ../vterm.el $out
    '';
  };

  inherit (darwin.apple_sdk.frameworks)
    WebKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore ImageCaptureCore
    CoreText CoreData;

in (emacs.override {
  srcRepo = true;
  nativeComp = true;
  withXwidgets = true;
}).overrideAttrs (o: {
  # Nix provides an old mac SDK (10.x for x86_64).
  # I think we need to use a later mac SDK to be able to build the macport properly,
  # use NS version for now.
  #
  # version = "28.1-mac-9.0.1";
  # src = fetchFromBitbucket {
  #   owner = "mituharu";
  #   repo = "emacs-mac";
  #   rev = "35bcea9b83e817aa9658051d6d5882eb25467a91";
  #   sha256 = "xp5mosrkaXentIt6gkV9GdLiw/GVzTCglL1d9pVb/OU=";
  # };

  buildInputs = o.buildInputs ++ [
    WebKit
    # Carbon
    # Cocoa
    # IOKit
    # OSAKit
    # Quartz
    # QuartzCore
    # ImageCaptureCore
    # CoreText
    # CoreData
  ];

  patches = [ ./patches/fix-window-role.patch ];

  postPatch = o.postPatch + ''
    substituteInPlace lisp/loadup.el \
    --replace '(emacs-repository-get-branch)' '"master"'
  '';

  # configureFlags =
  #   (filter (x: !(elem x [ "--with-ns" "--disable-ns-self-contained" ]))
  #     o.configureFlags) ++ [ "--with-mac" ];

  postInstall = o.postInstall + ''
    cp ${emacs-vterm}/vterm.el $out/share/emacs/site-lisp/vterm.el
    cp ${emacs-vterm}/vterm-module.so $out/share/emacs/site-lisp/vterm-module.so
  '';

  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -g -O2";
})

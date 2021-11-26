{ stdenv
, cmake
, libtool
, glib
, libvterm-neovim
, ncurses
, darwin
, emacs
, emacs-src
, emacs-vterm-src }:
let
  inherit (import ./settings.nix) emacsBranch emacsVersion;

  emacs-vterm = stdenv.mkDerivation {
    pname = "emacs-vterm";
    version = "master";

    src = emacs-vterm-src;

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

  emacs-mac = (emacs.override {
    srcRepo = true;
    nativeComp = true;
    withXwidgets = true;
  }).overrideAttrs (drv: {
    version = emacsVersion;
    src = emacs-src;

    buildInputs = drv.buildInputs ++ [ darwin.apple_sdk.frameworks.WebKit ];

    patches = [ ./patches/fix-window-role.patch ./patches/no-titlebar.patch ];

    postPatch = drv.postPatch + ''
      substituteInPlace lisp/loadup.el \
      --replace '(emacs-repository-get-branch)' '"${emacsBranch}"'
    '';

    postInstall = drv.postInstall + ''
      cp ${emacs-vterm}/vterm.el $out/share/emacs/site-lisp/vterm.el
      cp ${emacs-vterm}/vterm-module.so $out/share/emacs/site-lisp/vterm-module.so
    '';

    CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -g -O3";
  });
in emacs-mac

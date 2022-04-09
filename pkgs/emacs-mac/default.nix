{ stdenv
, cmake
, libtool
, glib
, libvterm-neovim
, ncurses
, emacs
, fetchFromGitHub
, darwin
}:
let
  inherit (import ./settings.nix) emacsBranch emacsVersion;

  emacs-vterm = stdenv.mkDerivation {
    pname = "emacs-vterm";
    version = "master";

    src = fetchFromGitHub {
      owner = "akermu";
      repo = "emacs-libvterm";
      rev = "a940dd2ee8a82684860e320c0f6d5e15d31d916f";
      sha256 = "uSzIDmRNk7u5VtCXYu+JVN7Gzkc65axCiK0Jq0X6MWQ=";
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

  emacs-mac = (emacs.override {
    srcRepo = true;
    nativeComp = true;
    withXwidgets = true;
  }).overrideAttrs (drv: {
    version = emacsVersion;
    src = fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "03e6a295d5c46151361845afbf5c8bcae915c89f";
      sha256 = "UwESuk8hDULYnrpinouzWw1R3C+drpYLMp4rXcvd4LA=";
    };

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

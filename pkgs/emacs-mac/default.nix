{ stdenv
, lib
, cmake
, libtool
, glib
, ncurses
, fetchurl
, pkg-config
, autoreconfHook
, texinfo
, makeWrapper
, libxml2
, gnutls
, gettext
, jansson
, libgccjit
, darwin
}:
let
  pname = "emacs";
  version = "28.1";
  macportVersion = "9.0";
  name = "emacs-${version}-mac-${macportVersion}";

  inherit (darwin) sigtool;
  inherit (darwin.apple_sdk.frameworks) AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit ImageCaptureCore GSS ImageIO;
in stdenv.mkDerivation {
  inherit pname version macportVersion name;

  NATIVE_FULL_AOT = "1";
  LIBRARY_PATH = "${lib.getLib stdenv.cc.libc}/lib";

  src = fetchurl {
    url = "https://bitbucket.org/mituharu/emacs-mac/get/${name}.tar.gz";
    sha256 = "967d5642ca47ae3de2626f0fc7163424e36925642827e151c3906179020dd90e";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config makeWrapper autoreconfHook texinfo ];

  buildInputs = [ ncurses libxml2 gnutls gettext jansson libgccjit sigtool
    AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
    ImageCaptureCore GSS ImageIO   # may be optional
  ];

  patches = [
    ./patches/fix-window-role.patch
    ./patches/multi-tty-27.diff
  ];

  postPatch = lib.concatStringsSep "\n" [
    "cp nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns mac/Emacs.app/Contents/Resources/Emacs.icns"

    # Add the name of the wrapped gvfsd
    # This used to be carried as a patch but it often got out of sync with upstream
    # and was hard to maintain for emacs-overlay.
    (lib.concatStrings (map (fn: ''
      sed -i 's#(${fn} "gvfs-fuse-daemon")#(${fn} "gvfs-fuse-daemon") (${fn} ".gvfsd-fuse-wrapped")#' lisp/net/tramp-gvfs.el
    '') [
      "tramp-compat-process-running-p"
      "tramp-process-running-p"
    ]))

    # Reduce closure size by cleaning the environment of the emacs dumper
    ''
      substituteInPlace src/Makefile.in \
        --replace 'RUN_TEMACS = ./temacs' 'RUN_TEMACS = env -i ./temacs'
    ''

    ''
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale
    for makefile_in in $(find . -name Makefile.in -print); do
      substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
    ''

    # Make native compilation work both inside and outside of nix build
    (let
      backendPath = (lib.concatStringsSep " "
        (builtins.map (x: ''\"-B${x}\"'') [
          # Paths necessary so the JIT compiler finds its libraries:
          "${lib.getLib libgccjit}/lib"
          "${lib.getLib libgccjit}/lib/gcc"
          "${lib.getLib stdenv.cc.libc}/lib"

          # Executable paths necessary for compilation (ld, as):
          "${lib.getBin stdenv.cc.cc}/bin"
          "${lib.getBin stdenv.cc.bintools}/bin"
          "${lib.getBin stdenv.cc.bintools.bintools}/bin"
        ]));
    in ''
      substituteInPlace lisp/emacs-lisp/comp.el --replace \
        "(defcustom native-comp-driver-options nil" \
        "(defcustom native-comp-driver-options '(${backendPath})"
    '')
    ""
  ];

  configureFlags = [
    "--disable-build-details" # for a (more) reproducible build
    "--with-xml2=yes"
    "--with-gnutls=yes"
    "--with-mac"
    "--with-modules"
    "--with-native-compilation"
    "--enable-mac-app=$$out/Applications"
  ];

  installTargets = [ "tags" "install" ];

  # CFLAGS = "-O3";
  # LDFLAGS = "-O3 -L${ncurses.out}/lib";

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el

    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`

    rm -r $out/share/emacs/$siteVersionDir/site-lisp

    # native comp with mac
    ln -snf $out/lib/emacs/*/native-lisp $out/Applications/Emacs.app/Contents/native-lisp

    echo "Generating native-compiled trampolines..."
    # precompile trampolines in parallel, but avoid spawning one process per trampoline.
    # 1000 is a rough lower bound on the number of trampolines compiled.
    $out/bin/emacs --batch --eval "(mapatoms (lambda (s) \
      (when (subr-primitive-p (symbol-function s)) (print s))))" \
      | xargs -n $((1000/NIX_BUILD_CORES + 1)) -P $NIX_BUILD_CORES \
        $out/bin/emacs --batch -l comp --eval "(while argv \
          (comp-trampoline-compile (intern (pop argv))))"
    mkdir -p $out/share/emacs/native-lisp
    $out/bin/emacs --batch \
      --eval "(add-to-list 'native-comp-eln-load-path \"$out/share/emacs/native-lisp\")" \
      -f batch-native-compile $out/share/emacs/site-lisp/site-start.el
  '';

  meta = {
    description = "The extensible, customizable text editor";
    homepage    = "https://www.gnu.org/software/emacs/";
    license     = lib.licenses.gpl3Plus;
    platforms   = lib.platforms.darwin;
  };
}

let
  _flake = builtins.getFlake (toString ../..);
  _pkgs = import <nixpkgs> {};
in
{ pkgs ? _pkgs
, package ? null
, maintainer ? null
, all ? false
, dont_prompt ? false
}:
let
  pkgs-mac = _flake.overlay {} pkgs;

  dont_prompt_str = if dont_prompt then "yes" else "no";

  packagesWith = cond: return: set:
    pkgs.lib.flatten
      (pkgs.lib.mapAttrsToList
        (name: pkg:
          let
            result = builtins.tryEval (
              if pkgs.lib.isDerivation pkg && cond name pkg
                then [(return name pkg)]
              else if pkg.recurseForDerivations or false || pkg.recurseForRelease or false
                then packagesWith cond return pkg
              else []
            );
          in
            if result.success then result.value
            else []
        )
        set
      );

  packagesWithUpdateScriptAndMaintainer = maintainer':
    let
      maintainer =
        if ! builtins.hasAttr maintainer' pkgs.lib.maintainers then
          builtins.throw "Maintainer with name `${maintainer'} does not exist in `lib/maintainers.nix`."
        else
          builtins.getAttr maintainer' pkgs.lib.maintainers;
    in
      packagesWith
        (name: pkg: builtins.hasAttr "updateScript" pkg &&
          (if builtins.hasAttr "maintainers" pkg.meta
            then (if builtins.isList pkg.meta.maintainers
                    then builtins.elem maintainer pkg.meta.maintainers
                    else maintainer == pkg.meta.maintainers
                )
            else false))
        (name: pkg: {
          pathName = name;
          package = pkg;
        }) pkgs-mac;

  packagesWithUpdateScript = packagesWith
    (name: pkg: builtins.hasAttr "updateScript" pkg)
    (name: pkg: {
      pathName = name;
      package = pkg;
    }) pkgs-mac;

  packageByName = pathName:
    let
        package = pkgs.lib.attrByPath (pkgs.lib.splitString "." pathName) null pkgs-mac;
    in
      if package == null then
        builtins.throw "Package with an attribute name `${pathName}` does not exists."
      else if ! builtins.hasAttr "updateScript" package then
        builtins.throw "Package with an attribute name `${pathName}` does have an `passthru.updateScript` defined."
      else
        { inherit pathName package; };

  packages =
    if package != null then
      [ (packageByName package) ]
    else if maintainer != null then
      packagesWithUpdateScriptAndMaintainer maintainer
    else if all then
      packagesWithUpdateScript
    else
      builtins.throw "No arguments provided.\n\n${helpText}";

  helpText = ''
    Please run:

        % nix-shell maintainers/scripts/update.nix --argstr maintainer foobar

    to run all update scripts for all packages that lists `foobar` as a maintainer
    and have `updateScript` defined, or:

        % nix-shell maintainers/scripts/update.nix --argstr package discord-mac

    to run update script for specific package, or:

        % nix-shell maintainers/scripts/update.nix --arg all true

    to run update scripts for all packages
  '';

  runUpdateScript = { package, pathName }:
    let
      logFile = (builtins.parseDrvName package.name).name + ".log";
      width = toString 40;
    in ''
      echo -ne " - ${package.name}: Updating ..."\\r
      ${package.updateScript} &> ${logFile}
      CODE=$?
      if [ "$CODE" != "0" ]; then
        echo " - ${package.name}: ERROR       "
        echo ""
        echo "--- SHOWING ERROR LOG FOR ${package.name} ----------------------"
        echo ""
        cat ${logFile}
        echo ""
        echo "--- SHOWING ERROR LOG FOR ${package.name} ----------------------"
        exit $CODE
      else
        nameVersion=$(nix-instantiate --eval -E "with import ./.; ${pathName}.name" | tr -d '"')
        if [[ $nameVersion == "${package.name}" ]]; then
          printf "%-${width}s -> %-${width}s \n" " - ${package.name}" "Up to date    "
        else
          printf "%-${width}s -> %-${width}s \n" " - ${package.name}" "$nameVersion  "
        fi

        rm ${logFile}
      fi
    '';

in pkgs.stdenv.mkDerivation {
  name = "mac-overlay-update-script";
  buildCommand = ''
    echo ""
    echo "----------------------------------------------------------------"
    echo ""
    echo "Not possible to update packages using `nix-build`"
    echo ""
    echo "${helpText}"
    echo "----------------------------------------------------------------"
    exit 1
  '';
  shellHook = ''
    unset shellHook
    echo ""
    echo "Going to be running update for following packages:"
    echo "${builtins.concatStringsSep "\n" (map (x: " - ${x.pathName}") packages)}"
    echo ""
    if [ "${dont_prompt_str}" = "no" ]; then
      read -n1 -r -s -p "Press space to continue..." confirm
    else
      confirm=""
    fi
    if [ "$confirm" = "" ]; then
      echo ""
      echo "Running update for:"
      ${builtins.concatStringsSep "\n" (map runUpdateScript packages)}
      echo ""
      echo "Packages updated!"
      exit 0
    else
      echo "Aborting!"
      exit 1
    fi
  '';
}

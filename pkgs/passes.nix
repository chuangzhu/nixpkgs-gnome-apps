{ lib
, python3
, fetchFromGitHub
, gtk4
, libadwaita
, gobject-introspection
, zint
, meson
, pkg-config
, ninja
, gettext
, glib
, desktop-file-utils
, blueprint-compiler
, wrapGAppsHook
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "passes";
  version = "unstable-2023-04-13";

  format = "other";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = pname;
    rev = "1039d9cf7441e3f14f3f6d7a3192809e2c38ec5e";
    hash = "sha256-3XHHF/4EcI7ZC1WFm51q3Hz0ZCr1Tu57zvDLgvVwTHc=";
  };

  postPatch = ''
    substituteInPlace src/model/meson.build --replace "'libzint', dirs: '/app/lib'" "'zint'"
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    glib
    desktop-file-utils
    blueprint-compiler
    wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
    zint
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = unstableGitUpdater { url = src.meta.homepage; };

  meta = with lib; {
    description = "Digital pass manager";
    homepage = "https://github.com/pablo-s/passes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

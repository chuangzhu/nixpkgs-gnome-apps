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
  version = "0.9-unstable-2024-05-27";

  format = "other";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = pname;
    rev = "75afeb69bc9c39fa81c46555cdb2fb52c56f4b03";
    hash = "sha256-g37KSrLp6Q9rDqeYRaIkYI496FFdVTJl6dYyULhjpho=";
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

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    url = src.meta.homepage;
  };

  meta = with lib; {
    description = "Digital pass manager";
    homepage = "https://github.com/pablo-s/passes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

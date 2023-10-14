{ lib
, python3
, fetchFromGitHub
, gtk4
, libadwaita_1_4
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
  version = "unstable-2023-09-28";

  format = "other";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = pname;
    rev = "d151ab2043bd25b76335743c5b8c3fc072f8ecb6";
    hash = "sha256-eo84gttNKVylMG/Q+K9hxLm08zDRNwXvpe4sFYM7czA=";
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
    libadwaita_1_4
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

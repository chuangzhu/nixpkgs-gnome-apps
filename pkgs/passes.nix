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
, blueprint-compiler_0_6
, wrapGAppsHook
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "passes";
  version = "unstable-2023-07-13";

  format = "other";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = pname;
    rev = "3d4f3e197ac6835e67188911ac6642ee09f7b86e";
    hash = "sha256-7l7q/DnZbIuI1347WDAHgashSEH/NboLDUgP2x67vbc=";
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
    blueprint-compiler_0_6
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

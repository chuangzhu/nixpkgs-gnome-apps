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
  version = "unstable-2023-11-20";

  format = "other";

  src = fetchFromGitHub {
    owner = "pablo-s";
    repo = pname;
    rev = "dc17c4f431bd37f2736981741ead68b90ec61aa9";
    hash = "sha256-z9VonDqe/meEzQL/fRgEs8Ux3xpDmQ2/PTN0Lj9gMgg=";
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

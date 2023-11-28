{ lib
, python3
, fetchFromGitHub
, gtk4
, libadwaita
, gobject-introspection
, meson
, pkg-config
, ninja
, gettext
, glib
, desktop-file-utils
, blueprint-compiler
, wrapGAppsHook4
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "flashcards";
  version = "unstable-2023-07-26";

  format = "other";

  src = fetchFromGitHub {
    owner = "fkinoshita";
    repo = "FlashCards";
    rev = "e1cd7bd7c7fb91e0aca0c1958b8c5f96b792bd19"; # main
    hash = "sha256-FiXbn+v05uF2/jJO75kv8aWNp+Uqz1z7QQdYw5H6WBs=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    glib
    desktop-file-utils
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
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
    description = "Memorize anything";
    homepage = "https://github.com/fkinoshita/FlashCards";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

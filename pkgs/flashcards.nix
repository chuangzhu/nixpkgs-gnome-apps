{ lib
, python3
, fetchFromGitHub
, gtk_4_11
, libadwaita_1_4
, gobject-introspection
, meson
, pkg-config
, ninja
, gettext
, glib
, desktop-file-utils
, blueprint-compiler
, wrapGAppsHook_4_11
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "flashcards";
  version = "unstable-2023-06-11";

  format = "other";

  src = fetchFromGitHub {
    owner = "fkinoshita";
    repo = "FlashCards";
    rev = "31d2be1cd5ea96be5266aedf24f73e8ac8a42c35"; # main
    hash = "sha256-aPnXazBWO+fjRbn1BzCO+kuYPT3y7SwPM97HK44Pm5Y=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    glib
    desktop-file-utils
    blueprint-compiler
    wrapGAppsHook_4_11
  ];

  buildInputs = [
    gtk_4_11
    libadwaita_1_4
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

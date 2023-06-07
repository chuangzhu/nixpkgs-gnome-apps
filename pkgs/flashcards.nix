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
, blueprint-compiler_0_8
, wrapGAppsHook_4_11
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "flashcards";
  version = "unstable-2023-06-07";

  format = "other";

  src = fetchFromGitHub {
    owner = "fkinoshita";
    repo = "FlashCards";
    rev = "c56e9f647a3d857b4a09d760d95c40acb1f43c68"; # main
    hash = "sha256-sIiuI5/e5VaRWY9nyLEffH1ts8PxOWtdNbyqc5n+ye0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    glib
    desktop-file-utils
    blueprint-compiler_0_8
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

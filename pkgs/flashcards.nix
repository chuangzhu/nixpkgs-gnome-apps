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
  version = "unstable-2023-06-08";

  format = "other";

  src = fetchFromGitHub {
    owner = "fkinoshita";
    repo = "FlashCards";
    rev = "44979d1cd6e271d226284d6c5c5017426999db43"; # main
    hash = "sha256-aDBB1Uxg+ic2zK60g9gPD0vh2Ku0T76mB2SVKuH3lIg=";
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

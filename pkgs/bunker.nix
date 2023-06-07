{ lib
, python3
, fetchFromSourcehut
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
, gopass
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "bunker";
  version = "unstable-2023-05-11";

  format = "other";

  src = fetchFromSourcehut {
    owner = "~quark97";
    repo = "Bunker";
    rev = "c250e2bf46b50534a65526f40380e2188e6a948b"; # master
    hash = "sha256-+YF7XwuqabHJ4JrO0WZ5Ef1g+HeL0B4qO6MGeCMiFB8=";
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
    pyotp
    python-benedict
    fuzzywuzzy
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
    )
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://git.sr.ht/~quark97/Bunker";
  };

  meta = with lib; {
    description = "GTK4 Frontend to GoPass";
    homepage = "https://sr.ht/~quark97/Bunker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

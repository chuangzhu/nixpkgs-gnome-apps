{ lib
, python3
, fetchFromSourcehut
, fetchpatch2
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

python3.pkgs.buildPythonApplication rec {
  pname = "bunker";
  version = "0-unstable-2023-05-11";

  format = "other";

  src = fetchFromSourcehut {
    owner = "~quark97";
    repo = "Bunker";
    rev = "c250e2bf46b50534a65526f40380e2188e6a948b"; # master
    hash = "sha256-+YF7XwuqabHJ4JrO0WZ5Ef1g+HeL0B4qO6MGeCMiFB8=";
  };
  patches = [
    (fetchpatch2 {
      url = "https://lists.sr.ht/~quark97/Bunker/%3C20241005072550.366436-1-chuang+git@melty.land%3E/raw";
      hash = "sha256-sBqzJB/dNTnCNC9qeJih8QVLR89TR2rCrXqGUDw1BWg=";
    })
    (fetchpatch2 {
      url = "https://lists.sr.ht/~quark97/Bunker/%3C20241005072550.366436-2-chuang+git@melty.land%3E/raw";
      hash = "sha256-wXS/1eGNpoop0ijKF/9tDU1Ku+6CcRLMUuJs/zIdbvs=";
    })
    (fetchpatch2 {
      url = "https://lists.sr.ht/~quark97/Bunker/%3C20241005072550.366436-3-chuang+git@melty.land%3E/raw";
      hash = "sha256-sQ0AfwVzWNlqApTweJdEdgkLpppyET4AnDM1WJ/+WM0=";
    })
    (fetchpatch2 {
      url = "https://lists.sr.ht/~quark97/Bunker/%3C20241005072550.366436-4-chuang+git@melty.land%3E/raw";
      hash = "sha256-ZiYu9lgfbzpstBirVe1FrJ7ndpcj/JTo+IdVGNAfjW0=";
    })
  ];

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

  passthru.updateScript = unstableGitUpdater { url = src.gitRepoUrl; hardcodeZeroVersion = true; };

  meta = with lib; {
    description = "GTK4 Frontend to GoPass";
    homepage = "https://sr.ht/~quark97/Bunker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

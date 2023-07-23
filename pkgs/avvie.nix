{ lib
, python3
, fetchFromGitHub
, gtk4
, libadwaita
, gobject-introspection
, meson
, pkg-config
, ninja
, desktop-file-utils
, wrapGAppsHook4
, gitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "avvie";
  version = "2.4";

  format = "other";

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Avvie";
    rev = "v${version}"; # master
    hash = "sha256-Y3Tf+EC7uwgVpHltV3qa5aY/5S3ANminfX5RNpGTQGA=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    piexif
    pycairo
    pillow
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = gitUpdater { url = src.meta.homepage; rev-prefix = "v"; };

  meta = with lib; {
    description = "GTK app for quick image cropping";
    homepage = "https://github.com/Taiko2k/Avvie";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

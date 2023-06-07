{ lib
, python3
, fetchFromGitLab
, gtk3
, libhandy
, gobject-introspection
, gst_all_1
, meson
, pkg-config
, ninja
, gettext
, glib
, desktop-file-utils
, wrapGAppsHook
, libsoup
, glib-networking
}:

python3.pkgs.buildPythonApplication {
  pname = "purism-stream";
  version = "unstable-2022-10-26";

  format = "other";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "todd";
    repo = "Stream";
    rev = "30f91232dabd3041094ba89e63bebb24dc45afd2"; # master
    sha256 = "sha256-IFs6xglPZ4pEmZRfAcDBjlzDBotX6rD4CVpPyI3HTfs=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    glib
    gtk3
    desktop-file-utils
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libhandy
    gobject-introspection
    libsoup
    glib-networking
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  meta = with lib; {
    description = "Mobile-friendly GTK YouTube client";
    homepage = "https://source.puri.sm/todd/Stream";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

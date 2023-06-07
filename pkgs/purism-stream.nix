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
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "purism-stream";
  version = "unstable-2022-11-03";

  format = "other";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "todd";
    repo = "Stream";
    rev = "2c897eb126f0993f4e564d64e8e4e591c348aed1"; # master
    sha256 = "sha256-EsF0UWioiN7g0vSJOQc+xt34+aRMpPPUvUcAmTdmhV0=";
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

  passthru.updateScript = unstableGitUpdater { url = src.meta.homepage; };

  meta = with lib; {
    description = "Mobile-friendly GTK YouTube client";
    homepage = "https://source.puri.sm/todd/Stream";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}

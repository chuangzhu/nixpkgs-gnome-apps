{ lib
, stdenv
, fetchFromGitLab
, gtk3
, libhandy
, json-glib
, systemdMinimal
, gobject-introspection
, wayland-protocols
, libxml2
, feedbackd
, presage
, gnome-desktop
, libxkbcommon
, meson
, cmake
, pkg-config
, ninja
, desktop-file-utils
, wrapGAppsHook
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "phosh-osk-stub";
  version = "0.28.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TRWYA8p/p2q5uCAUAc+0Una3DdKhYr9dGmGenZSOPro=";
  };

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/36468
    sed -i "/gio_dep/a gio_unix_dep = dependency('gio-unix-2.0', version: glib_ver_cmp)" meson.build
    sed -i '/gio_dep/a gio_unix_dep,' src/meson.build src/completers/meson.build
    # It won't autostart with this line
    sed -i "/OnlyShowIn=Phosh;/d" data/sm.puri.OSK0.desktop.in.in
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libhandy
    json-glib
    systemdMinimal
    gobject-introspection
    wayland-protocols
    libxml2
    feedbackd
    presage
    gnome-desktop
    libxkbcommon
  ];

  preInstall = ''
    mkdir -p $out/share/icons/hicolor/
  '';

  postInstall = ''
    mkdir -p $out/share/phosh/osk
    ln -sf ${presage}/share/presage $out/share/phosh/osk/presage
  '';

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Experimental keyboard for phosh";
    homepage = "https://gitlab.gnome.org/guidog/phosh-osk-stub";
    changelog = "https://gitlab.gnome.org/guidog/phosh-osk-stub/-/raw/v${version}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
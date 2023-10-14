# Copyright 2022, Nixpkgs contributors
# SPDX-License-Identifier: MIT
# https://github.com/NixOS/nixpkgs/pull/202692/

{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, cargo
, rustc
, meson
, pkg-config
, gtk_4_11
, itstool
, desktop-file-utils
, ninja
, wrapGAppsHook_4_11
, libadwaita_1_4
, gnome
, webp-pixbuf-loader
, gdk-pixbuf
, libgweather
, librsvg
, shared-mime-info
, libheif
, libxml2
, lcms2
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  version = "45.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "loupe";
    rev = finalAttrs.version;
    hash = "sha256-oJmcIY3sk7I3kVLWis4efN8C/cSwsqBokPR9QCaJa6o=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
  };

  nativeBuildInputs = [
    meson
    pkg-config
    gtk_4_11
    itstool
    desktop-file-utils # update-desktop-database
    ninja
    wrapGAppsHook_4_11
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    libadwaita_1_4
    gdk-pixbuf
    libgweather
    librsvg
    shared-mime-info
    libheif
    libxml2
    lcms2
  ];

  preInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
  '';

  # based on eog
  postInstall = ''
    # Pull in WebP support
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        librsvg
        webp-pixbuf-loader
      ];
    }}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { attrPath = finalAttrs.pname; };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/Incubator/loupe/";
    description = "A simple image viewer application written with GTK4 and Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
})

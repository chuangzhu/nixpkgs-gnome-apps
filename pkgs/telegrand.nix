{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, cargo
, rustc
, meson
, pkg-config
, desktop-file-utils
, ninja
, wrapGAppsHook
, blueprint-compiler
, gtk4
, libadwaita
, gdk-pixbuf
, rlottie, llvmPackages
, tdlib
, libshumate
, gst_all_1
, clippy
, unstableGitUpdater
}:

let
  gtk4_ = gtk4.overrideAttrs (old: {
    patches = old.patches ++ lib.singleton (fetchpatch {
      url = "https://github.com/paper-plane-developers/paper-plane/raw/380720b0a0915d230052f82f183df7a22e3a47e3/build-aux/gtk-reversed-list.patch";
      hash = "sha256-q1izvd9sE/WZ3s374EvN0I0GH1Em0YZOaNb+s8WyYsI=";
    });
  });
  wrapGAppsHook4_ = wrapGAppsHook.override { gtk3 = gtk4_; };
  tdlib_1_8_19 = tdlib.overrideAttrs (old: {
    version = "1.8.19";
    src = fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "2589c3fd46925f5d57e4ec79233cd1bd0f5d0c09";
      hash = "sha256-mbhxuJjrV3nC8Ja7N0WWF9ByHovJLmoLLuuzoU4khjU=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "paper-plane";
  version = "unstable-2023-11-03";

  src = fetchFromGitHub {
    owner = "paper-plane-developers";
    repo = "paper-plane";
    rev = "0cb40abfec19562a2e5b15b916b738cebb3645e3";
    hash = "sha256-qcAHxNnF980BHMqLF86M06YQnEN5L/8nkyrX6HQjpBA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "gtk-rlottie-0.1.0" = "sha256-/F0VSXU0Z59QyFYXrB8NLe/Nw/uVjGY68BriOySSXyI=";
      "origami-0.1.0" = "sha256-xh7eBjumqCOoAEvRkivs/fgvsKXt7UU67FCFt20oh5s=";
    };
  };

  nativeBuildInputs = [
    meson
    pkg-config
    desktop-file-utils # update-desktop-database
    ninja
    wrapGAppsHook4_
    blueprint-compiler
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk4
    libadwaita
    gdk-pixbuf
    rlottie
    tdlib_1_8_19
    libshumate
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
  ]);

  # Stolen from <nixpkgs/pkgs/applications/networking/instant-messengers/telegram/telegram-desktop/default.nix>
  mesonFlags = [
    "-Dtg_api_id=611335"
    "-Dtg_api_hash=d524b414d21f4d37f08684c1df41ac9c"
  ];

  checkInputs = [ clippy ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.meta.homepage; };

  meta = with lib; {
    homepage = "https://github.com/paper-plane-developers/paper-plane/";
    description = "Telegram client optimized for the GNOME desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.unix;
  };
})

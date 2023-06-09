{ lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, fetchpatch
, appstream
, rustPlatform
, meson
, pkg-config
, desktop-file-utils
, ninja
, wrapGAppsHook
, blueprint-compiler_0_8
, gtk4
, libadwaita
, gdk-pixbuf
, rlottie, llvmPackages
, tdlib
, gst_all_1
, clippy
, unstableGitUpdater
}:

let
  # With gtk_4_11 it launches, but panics after login
  # thread 'main' panicked at 'called `Option::unwrap()` on a `None` value', src/session/sidebar/avatar.rs:144:14
  gtk4_ = gtk4.overrideAttrs (old: {
    patches = old.patches ++ lib.singleton (fetchpatch {
      url = "https://github.com/paper-plane-developers/paper-plane/raw/380720b0a0915d230052f82f183df7a22e3a47e3/build-aux/gtk-reversed-list.patch";
      hash = "sha256-q1izvd9sE/WZ3s374EvN0I0GH1Em0YZOaNb+s8WyYsI=";
    });
  });
  libadwaita_1_4 = (libadwaita.override { gtk4 = gtk4_; }).overrideAttrs (old: {
    version = "unstable-2023-03-29";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = "57bc21b4c51aa361609fe6f57031630589391b0b";
      hash = "sha256-5C0tHLO2OoR2KsqRqetSw+JeW4Cfcrj/uLouAAUgrTE=";
    };
    buildInputs = old.buildInputs ++ [ appstream ];
  });
  wrapGAppsHook4 = wrapGAppsHook.override { gtk3 = gtk4_; };

  tdlib_1_8_14 = tdlib.overrideAttrs (old: {
    version = "1.8.14";
    src = fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "8517026415e75a8eec567774072cbbbbb52376c1";
      hash = "sha256-Q6p/DAyAF1mVhIbjgITjCmynb5Y/fajhBL6/POrNWmE=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "paper-plane";
  version = "unstable-2023-06-08";

  src = fetchFromGitHub {
    owner = "paper-plane-developers";
    repo = "paper-plane";
    rev = "cf4439ce3f8d52d971a9bde257d864083bcf21f6";
    hash = "sha256-62/4Yyuzkc+tEOl96ba3SHPRe1L6TDcFLcC13D3bA7U=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "gtk-rlottie-0.1.0" = "sha256-gFjyJVQZ7/l6O04QP0ORbW8LWoQ19oyO9E+Z+ehefco=";
      "libadwaita-0.3.1" = "sha256-LJE5eGyrv0ZCcHFvnf5KNT08vphIlygszfuCZvNBEkQ=";
    };
  };

  nativeBuildInputs = [
    meson
    pkg-config
    desktop-file-utils # update-desktop-database
    ninja
    wrapGAppsHook4
    blueprint-compiler_0_8
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4_
    libadwaita_1_4
    gdk-pixbuf
    rlottie
    tdlib_1_8_14
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
  ]);

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion llvmPackages.clang}/include -isystem ${rlottie}/include";

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

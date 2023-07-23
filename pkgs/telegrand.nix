{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, rustc
, meson
, pkg-config
, desktop-file-utils
, ninja
, wrapGAppsHook_4_11
, blueprint-compiler_0_8
, gtk_4_11
, libadwaita_1_4
, gdk-pixbuf
, rlottie, llvmPackages
, tdlib
, gst_all_1
, clippy
, unstableGitUpdater
}:

let
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
  version = "unstable-2023-07-08";

  src = fetchFromGitHub {
    owner = "paper-plane-developers";
    repo = "paper-plane";
    rev = "4a9945429cdc446b323e390e8c1163944582051e";
    hash = "sha256-/kNdojus3OTaHR46MdTq+dp/nAvwme/+YgGbB8Na/1s=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "gtk-rlottie-0.1.0" = "sha256-gFjyJVQZ7/l6O04QP0ORbW8LWoQ19oyO9E+Z+ehefco=";
    };
  };

  nativeBuildInputs = [
    meson
    pkg-config
    desktop-file-utils # update-desktop-database
    ninja
    wrapGAppsHook_4_11
    blueprint-compiler_0_8
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk_4_11
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

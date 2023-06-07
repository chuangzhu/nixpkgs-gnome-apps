{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
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
  version = "unstable-2023-05-28";

  src = fetchFromGitHub {
    owner = "paper-plane-developers";
    repo = "paper-plane";
    rev = "a79040ff8da33566d8e200e3d827d4070b024cc9";
    hash = "sha256-dgmhmLWePG3YDrlulP2FQFxbagNSA+/6/mWJSAqagfA=";
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
    wrapGAppsHook_4_11
    blueprint-compiler_0_8
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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

  meta = with lib; {
    homepage = "https://github.com/paper-plane-developers/paper-plane/";
    description = "Telegram client optimized for the GNOME desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.unix;
  };
})
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
, blueprint-compiler
, gtk_4_11
, libadwaita_1_4
, gdk-pixbuf
, rlottie, llvmPackages
, tdlib
, libshumate
, gst_all_1
, clippy
, unstableGitUpdater
}:

let
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
  version = "unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "paper-plane-developers";
    repo = "paper-plane";
    rev = "1e62a29657aa034b81a5be2f79daf5bb9a6a98ed";
    hash = "sha256-W+G+S5lDOEOkcYnDavbfleaVkv2qMGLLc8P7ta0yzZY=";
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
    wrapGAppsHook_4_11
    blueprint-compiler
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk_4_11
    libadwaita_1_4
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

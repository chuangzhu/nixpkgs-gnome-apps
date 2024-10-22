{ lib
, stdenv
, rustPlatform
, cargo
, rustc
, fetchFromGitLab
, gtk4
, libadwaita
, openssl
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, glib
, appstream-glib
, desktop-file-utils
# , blueprint-compiler
, buildPackages
, sqlite
, clapper
, gst_all_1
, gtuber
, glib-networking
, gnome
, webp-pixbuf-loader
, librsvg
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipeline";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8LKd7zZuwo/HtxFo8x8UpO1Y8/DnTZmaOYrc9NmnIrc=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "clapper-0.1.0" = "sha256-IFFqfSq2OpzfopQXSYfnJ68HGLY+rvcLqk7NTdDd+28=";
      "piped-openapi-sdk-1.0.0" = "sha256-UFzMYYqCzO6KyJvjvK/hBJtz3FOuSC2gWjKp72WFEGk=";
      "pipeline-api-0.1.0" = "sha256-h094ZAJOqX9QC1EUAtzIVztudhndXglkYLcFbH/mpqQ=";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    cargo
    rustPlatform.cargoSetupHook
    rustc
    pkg-config
    wrapGAppsHook4
    glib
    appstream-glib
    desktop-file-utils

    # https://nixpk.gs/pr-tracker.html?pr=348481
    (buildPackages.blueprint-compiler.overrideAttrs {
      version = "0.14.0";
      src = buildPackages.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "jwestman";
        repo = "blueprint-compiler";
        rev = "v0.14.0";
        hash = "sha256-pkbTxCN7LagIbOtpiUCkh40aHw6uRtalQVFa47waXjU=";
      };
    })
  ];
  buildInputs = [
    gtk4
    libadwaita
    openssl
    sqlite
    clapper

    # These should be clapper's propagatedBuildInputs
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad
    gtuber
    glib-networking # For GIO_EXTRA_MODULES. Fixes "TLS support is not available"
  ];

  # Pull in WebP support for YouTube avatars.
  # In postInstall to run before gappsWrapperArgsHook.
  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        webp-pixbuf-loader
        librsvg
      ];
    }}"
  '';

  passthru.updateScript = nix-update-script { attrPath = finalAttrs.pname; };

  meta = with lib; {
    description = "Watch YouTube and PeerTube videos in one place";
    homepage = "https://mobile.schmidhuberj.de/pipeline";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
})

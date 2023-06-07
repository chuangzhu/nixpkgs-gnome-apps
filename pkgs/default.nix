{ lib
, fetchFromGitLab
, gtk4
, wrapGAppsHook
, libadwaita
, appstream
, blueprint-compiler
, ...
} @ pkgs:

let
  callPackage = lib.callPackageWith (pkgs // rec {
    gtk_4_11 = gtk4.overrideAttrs (old: rec {
      version = "4.11.3";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "gtk";
        rev = version;
        hash = "sha256-KCGqVt2nFfzumPxsR2X2VbYLZNLKgV+LhBf8wsV9KP0=";
      };
      patches = [ ./gtk-reversed-list.patch ];
      postPatch = old.postPatch + ''
        patchShebangs build-aux/meson/gen-visibility-macros.py
      '';
    });
    wrapGAppsHook_4_11 = wrapGAppsHook.override { gtk3 = gtk_4_11; };

    libadwaita_1_4 = (libadwaita.override { gtk4 = gtk_4_11; }).overrideAttrs (old: {
      version = "unstable-2023-06-05";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libadwaita";
        rev = "d5af77fd33265e8308f6f05b26d514376c79b0ce";
        hash = "sha256-+uKG4igj6WMVUuNom4+eVczYTa9VrDhXOBH5Rqx7igs=";
      };
      buildInputs = old.buildInputs ++ [ appstream ];
    });

    blueprint-compiler_0_8 = blueprint-compiler.overrideAttrs (old: rec {
      version = "0.8.1";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "jwestman";
        repo = "blueprint-compiler";
        rev = "v${version}";
        hash = "sha256-3lj9BMN5aNujbhhZjObdTOCQfH5ERQCgGqIAw5eZIQc=";
      };
      doCheck = false;
    });
  });
in

{
  purism-stream = callPackage ./purism-stream.nix { };
  gadgetcontroller = callPackage ./gadgetcontroller.nix { };
  phosh-osk-stub= callPackage ./phosh-osk-stub.nix { };
  bunker = callPackage ./bunker.nix { };
  passes = callPackage ./passes.nix { };
  avvie = callPackage ./avvie.nix { };
  paper-note = callPackage ./paper-note.nix { };
  snapshot = callPackage ./snapshot.nix { };
  telegrand = callPackage ./telegrand.nix { };
  flashcards = callPackage ./flashcards.nix { };
  loupe = callPackage ./loupe.nix { };
}

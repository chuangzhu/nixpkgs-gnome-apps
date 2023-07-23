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
      version = "4.11.4";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "gtk";
        rev = version;
        hash = "sha256-YobWcLJm8owjrz6c6aPMCrVZqYDvNpjIt5Zea2CtAZY=";
      };
      patches = [ ./gtk-reversed-list.patch ];
      postPatch = old.postPatch + ''
        patchShebangs build-aux/meson/gen-visibility-macros.py
      '';
    });
    wrapGAppsHook_4_11 = wrapGAppsHook.override { gtk3 = gtk_4_11; };

    libadwaita_1_4 = (libadwaita.override { gtk4 = gtk_4_11; }).overrideAttrs (old: rec {
      version = "1.4.alpha";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libadwaita";
        rev = version;
        hash = "sha256-UUS5b6diRenpxxmGvVJoc6mVjEVGS9afLd8UKu+CJvI=";
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
  tubefeeder = callPackage ./tubefeeder.nix { };
  iplan = callPackage ./iplan.nix { };
}

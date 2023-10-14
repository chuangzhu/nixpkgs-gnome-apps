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
      version = "4.12.3";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "gtk";
        rev = version;
        hash = "sha256-KOAGRP1n1D1VR7B3kATijcJP1VDcH6nnYVNno1Lu6T8=";
      };
      patches = [ ./gtk-reversed-list.patch ];
      postPatch = old.postPatch + ''
        patchShebangs build-aux/meson/gen-visibility-macros.py
      '';
    });
    wrapGAppsHook_4_11 = wrapGAppsHook.override { gtk3 = gtk_4_11; };

    libadwaita_1_4 = (libadwaita.override { gtk4 = gtk_4_11; }).overrideAttrs (old: rec {
      version = "1.4.0";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "libadwaita";
        rev = version;
        hash = "sha256-LXrlTca50ALo+Nm55fwXNb4k3haLqHNnzLPc08VhA5s=";
      };
      buildInputs = old.buildInputs ++ [ appstream ];
    });

    blueprint-compiler_0_6 = blueprint-compiler.overrideAttrs (old: rec {
      version = "0.6.0";
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "jwestman";
        repo = "blueprint-compiler";
        rev = "v${version}";
        hash = "sha256-L6EGterkZ8EB6xSnJDZ3IMuOumpTpEGnU74X3UgC7k0=";
      };
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
  # paper-note = callPackage ./paper-note.nix { };
  # snapshot = callPackage ./snapshot.nix { };
  # telegrand = callPackage ./telegrand.nix { };
  flashcards = callPackage ./flashcards.nix { };
  loupe = callPackage ./loupe.nix { };
  pipeline = callPackage ./tubefeeder.nix { };
  iplan = callPackage ./iplan.nix { };
}

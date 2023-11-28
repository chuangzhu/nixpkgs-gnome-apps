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
  telegrand = callPackage ./telegrand.nix { };
  flashcards = callPackage ./flashcards.nix { };
  pipeline = callPackage ./tubefeeder.nix { };
  iplan = callPackage ./iplan.nix { };
}

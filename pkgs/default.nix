{ callPackage, ... }:

{
  purism-stream = callPackage ./purism-stream.nix { };
  gadgetcontroller = callPackage ./gadgetcontroller.nix { };
  phosh-osk-stub= callPackage ./phosh-osk-stub.nix { };
  bunker = callPackage ./bunker.nix { };
  avvie = callPackage ./avvie.nix { };
  flashcards = callPackage ./flashcards.nix { };
  dewduct = callPackage ./dewduct.nix { };
}

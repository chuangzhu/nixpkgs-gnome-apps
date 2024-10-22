{ callPackage, ... }:

rec {
  purism-stream = callPackage ./purism-stream.nix { };
  gadgetcontroller = callPackage ./gadgetcontroller.nix { };
  phosh-osk-stub= callPackage ./phosh-osk-stub.nix { };
  bunker = callPackage ./bunker.nix { };
  avvie = callPackage ./avvie.nix { };
  flashcards = callPackage ./flashcards.nix { };
  gtuber = callPackage ./gtuber.nix { };
  pipeline = callPackage ./tubefeeder.nix { inherit gtuber; };
  dewduct = callPackage ./dewduct.nix { };
}

{ callPackage, symlinkJoin, ... }:

rec {
  purism-stream = callPackage ./purism-stream.nix { };
  gadgetcontroller = callPackage ./gadgetcontroller.nix { };
  phosh-osk-stub= callPackage ./phosh-osk-stub.nix { };
  bunker = callPackage ./bunker.nix { };
  avvie = callPackage ./avvie.nix { };
  flashcards = callPackage ./flashcards.nix { };
  dewduct = callPackage ./dewduct.nix { };
  libhighscore = callPackage ./libhighscore.nix { };
  highscore = callPackage ./highscore.nix { inherit libhighscore; };
  highscore-mgba = callPackage ./highscore-mgba.nix { inherit libhighscore; };
  highscore-nestopia = callPackage ./highscore-nestopia.nix { inherit libhighscore; };
  highscore-with-all-cores = symlinkJoin {
    name = "highscore";
    paths = [ highscore highscore-mgba highscore-nestopia ];
  };
}

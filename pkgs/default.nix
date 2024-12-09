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
  highscore-with-all-cores = symlinkJoin {
    name = "highscore";
    paths = builtins.filter (p: p.meta.available) [
      highscore
      highscore-blastem
      highscore-bsnes
      highscore-desmume
      highscore-gearsystem
      highscore-mednafen
      highscore-mgba
      # highscore-mupen64plus
      highscore-nestopia
      highscore-prosystem
      highscore-stella
    ];
  };
  highscore-blastem = callPackage ./highscore-blastem.nix { inherit libhighscore; };
  highscore-bsnes = callPackage ./highscore-bsnes.nix { inherit libhighscore; };
  highscore-desmume = callPackage ./highscore-desmume.nix { inherit libhighscore; };
  highscore-gearsystem = callPackage ./highscore-gearsystem.nix { inherit libhighscore; };
  highscore-mednafen = callPackage ./highscore-mednafen.nix { inherit libhighscore; };
  highscore-mgba = callPackage ./highscore-mgba.nix { inherit libhighscore; };
  # highscore-mupen64plus = callPackage ./highscore-mupen64plus.nix { inherit libhighscore; };
  highscore-nestopia = callPackage ./highscore-nestopia.nix { inherit libhighscore; };
  highscore-prosystem = callPackage ./highscore-prosystem.nix { inherit libhighscore; };
  highscore-stella = callPackage ./highscore-stella.nix { inherit libhighscore; };
}

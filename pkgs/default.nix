{ callPackage, ... }:

rec {
  purism-stream = callPackage ./purism-stream.nix { };
  phosh-osk-stub= callPackage ./phosh-osk-stub.nix { };
  bunker = callPackage ./bunker.nix { };
  avvie = callPackage ./avvie.nix { };
  flashcards = callPackage ./flashcards.nix { };
  dewduct = callPackage ./dewduct.nix { };
  libhighscore = callPackage ./libhighscore.nix { };
  highscore-unwrapped = callPackage ./highscore-unwrapped.nix { inherit libhighscore; };
  highscore = callPackage ./highscore-wrapper.nix {
    inherit
      highscore-unwrapped
      highscore-blastem
      highscore-bsnes
      highscore-desmume
      highscore-gearsystem
      highscore-mednafen
      highscore-mgba
      highscore-mupen64plus
      highscore-nestopia
      highscore-prosystem
      highscore-stella;
  };
  highscore-with-all-cores = throw "highscore-with-all-cores is renamed to highscore";
  highscore-blastem = callPackage ./highscore-blastem.nix { inherit libhighscore; };
  highscore-bsnes = callPackage ./highscore-bsnes.nix { inherit libhighscore; };
  highscore-desmume = callPackage ./highscore-desmume.nix { inherit libhighscore; };
  highscore-gearsystem = callPackage ./highscore-gearsystem.nix { inherit libhighscore; };
  highscore-mednafen = callPackage ./highscore-mednafen.nix { inherit libhighscore; };
  highscore-mgba = callPackage ./highscore-mgba.nix { inherit libhighscore; };
  highscore-mupen64plus = callPackage ./highscore-mupen64plus.nix { inherit libhighscore; };
  highscore-nestopia = callPackage ./highscore-nestopia.nix { inherit libhighscore; };
  highscore-prosystem = callPackage ./highscore-prosystem.nix { inherit libhighscore; };
  highscore-stella = callPackage ./highscore-stella.nix { inherit libhighscore; };
}

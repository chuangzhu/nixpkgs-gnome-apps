Out-of-tree Nix packages set for various GNOME apps. They aren't in Nixpkgs because:

* There is already a PR for it, but for some reason it isn't merged yet.
* The app requires a newer version of GNOME runtime than the one in Nixpkgs.
* The app isn't released yet. [Do not ship work in progress](https://dont-ship.it/)
* The packaging still needs some work.
* The app itself isn't mature enough.

In long term all of them should be upstreamed to Nixpkgs, but this overlay is for anyone who wants to try these apps *now*.

## Usage

Launch directly:

```shellsession
$ nix --extra-experimental-features='nix-command flakes' run github:chuangzhu/nixpkgs-gnome-apps#flashcards
```

Install imperatively:

```shellsession
$ nix --extra-experimental-features='nix-command flakes' profile install github:chuangzhu/nixpkgs-gnome-apps#flashcards
```

Install declaratively (NixOS):

```nix
inputs.gnome-apps.url = "github:chuangzhu/nixpkgs-gnome-apps";
outputs = { nixpkgs, gnome-apps, ... }: {
  nixosConfigurations.your-host-name = nixpkgs.lib.nixosSystem {
    modules = [ { environment.systemPackages = [ gnome-apps.packages.x86_64-linux.flashcards ]; } ];
  };
};
```

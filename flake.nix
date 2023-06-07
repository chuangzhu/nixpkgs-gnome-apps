{
  description = "Out-of-tree Nix packages set for various GNOME apps";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, ... }: let
    # Flake helpers considered harmful!
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays.default = final: prev: import ./pkgs prev;

    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        shellHook = ''
          PS1="\n\[\033[1;33m\][nixpkgs-gnome-apps:\w]\$\[\033[0m\] "
        '';
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          # Update all packages with passthru.updateScript in this flake
          # Tested: unstableGitUpdater, gitUpdater, nix-update-script, writeShellScript
          # Note that unstable-updater.nix and list-git-tags don't handle `importTree` correctly for
          # flake-compat (as update-source-version do), so be sure to pass the `url` argument
          (with lib; writeShellScriptBin "update" (foldlAttrs (acc: name: value: acc + "\n" +
            optionalString (value.passthru ? updateScript) (
              let script = value.passthru.updateScript.command or value.passthru.updateScript; in
              "UPDATE_NIX_ATTR_PATH=packages.${stdenv.hostPlatform.system}.${name} ${escapeShellArgs script}" +
              (optionalString (hasInfix "nix-update" (toString script)) " --flake"))
          ) "set -xe" self.packages.${stdenv.hostPlatform.system}))
        ];
      };
    });

  };
}

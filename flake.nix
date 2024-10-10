{
  description = "Unbound and Valkey container flake";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      nixosModules = forAllSystems (system: {
        fast-unbound-container = import ./modules/container.nix;
      });
      checks = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          fast-unbound-test = import ./tests/test-unbound-valkey.nix { inherit pkgs; };
        }
      );

      devShells = forAllSystems
        (system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          import ./dev-shell.nix { inherit pkgs; }
        );
    };
}

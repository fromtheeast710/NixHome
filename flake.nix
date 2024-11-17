{
  description = "NixOS config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lstodo.url = "github:fromtheeast710/lstodo";
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: with inputs;
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ # TODO: Get system using lib
        "x86_64-linux"
        "aarch64-linux"
      ];
      
      imports = [ ];

      flake = {
        nixosModules = config.flake.lib.dirToAttrs ./modules/nixos;

        nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
          ];
        };};

      perSystem = { pkgs, config, ... }: {
        devShells.default = with pkgs;
          mkShellNoCC {
            packages = [ 
              nixd 
              alejadra
            ];
          };};
    };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    import-tree.url = "github:denful/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-aspects.url = "github:denful/flake-aspects";
    nix-wrapper-modules = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-aspects.flakeModule
        inputs.flake-parts.flakeModules.modules
        inputs.nix-wrapper-modules.flakeModules.wrappers
        (inputs.import-tree ./modules)
      ];

      systems = ["x86_64-linux"];
    };
}

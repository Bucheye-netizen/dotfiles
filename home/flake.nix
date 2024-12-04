{
  description = "Home Manager configuration of lisan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor.url = "github:hyprwm/hyprcursor";
    ags.url = "github:Aylur/ags";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    ags,
    hyprcursor,
    self,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."lisan" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      extraSpecialArgs = {
        inherit nixvim;
        inherit ags;
        inherit hyprcursor;
        inherit self;
      };
    };
  };
}

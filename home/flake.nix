{
  description = "Home Manager configuration of lisan";

  inputs = {
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
    ags.url = "github:aylur/ags";
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
      modules = [
        nixvim.homeManagerModules.nixvim
        ags.homeManagerModules.default
        ./home.nix
        ./hyprland.nix
        ./vscode.nix
        ./nvim.nix
        ./terminal/terminal.nix
        ./fastfetch.nix
        ./helix.nix
      ];

      extraSpecialArgs = {
        inherit nixvim;
        inherit ags;
        inherit hyprcursor;
        inherit self;
      };
    };
  };
}

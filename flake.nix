{
  description = "Nixos config flake";

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

		zjstatus = {
      url = "github:dj95/zjstatus";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, zjstatus, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
				home-manager.nixosModules.home-manager 
				{
					home-manager.extraSpecialArgs = {inherit inputs;};
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.lisan = import ./home.nix;
				}
      ];
    };
  };
}


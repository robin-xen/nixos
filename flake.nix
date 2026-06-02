{
  description = "Robin's NixOS system";

  inputs = {
    nixpkgs-system.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-home.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-home";
    };
  };

  outputs = { self, nixpkgs-system, nixpkgs-home, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs-home {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # ─────────────────────────────────────────────
    # NixOS system (NO Home Manager here)
    # ─────────────────────────────────────────────
    nixosConfigurations.transcendent = nixpkgs-system.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
      ];
    };

    # ─────────────────────────────────────────────
    # Home Manager (standalone)
    # ─────────────────────────────────────────────
    homeConfigurations.robin =
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [
          ./home/robin.nix
        ];
      };
  };
}

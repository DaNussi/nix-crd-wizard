{
  description = "CR(D) Wizard - Kubernetes CRD visualization and exploration tool (TUI)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, flake-utils }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = flake-utils.lib.defaultSystems;

      perSystem = { config, self', inputs', pkgs, system, ... }:
        {
          packages = {
            default = self'.packages.crd-wizard;

            crd-wizard = pkgs.buildGoModule rec {
              pname = "crd-wizard";
              version = "dev";
              src = ./.;

              vendorHash = "sha256-9+HZL11PQuIndbXcZg+cYPBESX9eSWrKsw9/5crXzGw=";

              subPackages = [ "." ];

              ldflags = [
                "-s"
                "-w"
              ];

              meta = with pkgs.lib; {
                description = "Kubernetes CRD visualization and exploration tool (TUI)";
                homepage = "https://github.com/pehlicd/crd-wizard";
                license = licenses.gpl3Only;
                maintainers = [ ];
                platforms = platforms.linux ++ platforms.darwin;
              };
            };
          };

          devShells.default = pkgs.mkShell {
            name = "crd-wizard-dev";
            buildInputs = with pkgs; [
              go
              kubectl
              kind
              git
              gnumake
            ];

            shellHook = ''
              echo "CRD Wizard TUI Development Environment"
              echo "Go version: $(go version | cut -d' ' -f3)"
            '';
          };

          apps.default = {
            type = "app";
            program = "${self'.packages.crd-wizard}/bin/crd-wizard";

            meta = with pkgs.lib; {
              description = "Kubernetes CRD visualization and exploration tool (TUI)";
              homepage = "https://github.com/pehlicd/crd-wizard";
              license = licenses.gpl3Only;
              maintainers = [ ];
              platforms = platforms.linux ++ platforms.darwin;
            };
          };
        };
    };
}

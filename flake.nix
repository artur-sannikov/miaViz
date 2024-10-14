{
  description = "Nix Flake for miaViz R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        miaViz = pkgs.rPackages.buildRPackage {
          name = "miaViz";
          src = self;
          propagatedBuildInputs = builtins.attrValues {
            inherit (pkgs.rPackages)
              ape
              BiocGenerics
              BiocParallel
              DelayedArray
              DirichletMultinomial
              dplyr
              ggnewscale
              ggrepel
              ggtree
              purrr
              rlang
              S4Vectors
              scater
              SingleCellExperiment
              tibble
              tidygraph
              tidyr
              tidytext
              tidytree
              viridis
              ;
          };
        };
      in
      {
        packages.default = miaViz;
        devShells.default = pkgs.mkShell {
          buildInputs = [ miaViz ];
          inputsFrom = pkgs.lib.singleton miaViz;
        };
      }
    );
}

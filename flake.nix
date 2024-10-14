{
  description = "Nix Flake for miaViz R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mia-flake.url = "github:artur-sannikov/mia/nix-flakes";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      mia-flake,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        mia = mia-flake.packages.${system}.default;
        miaViz = pkgs.rPackages.buildRPackage {
          name = "miaViz";
          src = self;
          propagatedBuildInputs =
            builtins.attrValues {
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
                TreeSummarizedExperiment
                ggraph
                ;
            }
            ++ [
              # Install the latest version of mia
              mia
            ];
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

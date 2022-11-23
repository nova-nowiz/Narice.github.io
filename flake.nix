{
  description = "Developement environment for Nix users";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, devshell, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell =
        let pkgs = import nixpkgs {
          inherit system;

          overlays = [ devshell.overlay ];
        };
        in
        pkgs.devshell.mkShell {
          imports = [ "${pkgs.devshell.extraModulesDir}/language/c.nix" ];
          commands = [
            {
              package = pkgs.devshell.cli;
              help = "Per project developer environments";
            }
            {
              package = pkgs.hugo;
            }
            {
              category = "dev shortcuts";
              name = "start-dev";
              help = "starts hugo with draft posts";
              command = "hugo server -D --navigateToChanged";
            }
            {
              category = "dev shortcuts";
              name = "start-prod";
              help = "start hugo without draft posts";
              command = "hugo server --navigateToChanged";
            }
          ];
          devshell.packages = with pkgs; [
            languagetool
            go
            nodePackages.vscode-langservers-extracted
          ];
          language.c.libraries = with pkgs; [
          ];
        };
    });
}

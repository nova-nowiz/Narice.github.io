+++
title = "TIL: Custom commands for DevOS's DevShell!"
author = ["Narice"]
description = "Build amazing dev tools super fast!"
date = 2022-11-18T16:51:00+01:00
lastmod = 2022-11-23T19:28:00+01:00
tags = ["nix", "linux", "nixos", "devos", "devshell"]
draft = false
creator = "Emacs 29.0.50 (Org mode 9.6 + ox-hugo)"
+++

## Introduction {#introduction}

If you are using [DevOS](https://github.com/divnix/digga/tree/main/examples/devos) which is the official template for using [digga](https://github.com/divnix/digga), you may find that some friendlier commands are needed for example to rebuild your `NixOS` system.
In this blog post, we'll cover exactly how to do that! :grin:


## Implementation {#implementation}

In your `<your-config>/shell/devos.nix` file, you will find a `commands` list, where you're be able to add your own set of commands:

```nix
{ pkgs, extraModulesPath, inputs, lib, ... }:
...
{
  ...
  commands = [
    ...
    { # A command shipped with devos
      category = "devos";
      name = nvfetcher-bin.pname;
      help = nvfetcher-bin.meta.description;
      command = "cd $PRJ_ROOT/pkgs; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml $@";
    }
    { # Our custom command!
      category = "devos";
      name = "switch";
      help = "Makes rebuilding easy! | usage: switch <config>";
      command = "sudo nixos-rebuild switch --flake .#$@";
    }
    ...
  ]
  ;
}
```

In this case, we added a `switch` command!
We provided a name for it, a help message, as well as the command that will be executed when using `switch`.

After reloading the `envrc` using `direnv reload` in the command line, we get the following prompt:

```shell
[devos]

  agenix               - age-encrypted secrets for NixOS
  cachix               - Command line client for Nix binary cache hosting https://cachix.org
  deploy-rs            - A Simple multi-profile Nix-flake deploy tool
  nix                  - Powerful package manager that makes package management reliable and reproducible
  nixos-generators     - Collection of image builders
  nvfetcher            - Generate nix sources expr for the latest version of packages
  switch               - Makes rebuilding easy! | usage: switch <config>

[docs]

  mdbook               - Create books from MarkDown

[general commands]

  menu                 - prints this menu

[linter]

  editorconfig-checker - A tool to verify that your files are in harmony with your .editorconfig
  nixpkgs-fmt          - Nix code formatter for nixpkgs
```

The custom `switch` command in under the `devos` section/category, with the help message that we wanted.


## Results {#results}

And we can now rebuild and switch to a new or different version of our NixOS/DevOS config super easily :partying_face:!

```shell
switch <your-config>
# Instead of:
sudo nixos-rebuild switch --flake .#<your-config>
```

{
  description = "AWFixer Sites — Nix flake providing Prisma native binaries (Prisma 7 engines + CLI)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        shellHook = ''
          export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines_7}/bin/schema-engine"
          # OpenSSL for Prisma's engine communication.
          export PKG_CONFIG_PATH="${pkgs.openssl_3.dev}/lib/pkgconfig''${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"

        '';
      in
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            # Prisma 7 — CLI + native engines
            prisma_7
            prisma-engines_7
            # Required by Prisma engines at runtime
            openssl_3
            gleam
            elixir
            erlang
            erlang-language-platform
            rebar3
            chromedriver
          ];
          inherit shellHook;
        };

        packages = {
          prisma = pkgs.prisma_7;
          prisma-engines = pkgs.prisma-engines_7;
          default = pkgs.prisma_7;
        };
      });
}

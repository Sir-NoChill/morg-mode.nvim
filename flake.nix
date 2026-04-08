{
  description = "morg-mode.nvim — Neovim plugin for morg-mode";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # LuaJIT environment with all test/dev dependencies
        luaEnv = pkgs.luajit.withPackages (ps: with ps; [
          busted
          nlua
          luafilesystem
          luacheck
          luacov
        ]);

        # Python for mdformat
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          mdformat
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            # Neovim
            pkgs.neovim

            # Lua (LuaJIT-based — matches nvim runtime)
            luaEnv

            # Lua tooling
            pkgs.stylua
            pkgs.lua-language-server

            # Documentation
            pythonEnv

            # Pre-commit
            pkgs.pre-commit
          ];

          shellHook = ''
            echo "morg-mode.nvim dev shell"
            echo "  make test             — run busted tests"
            echo "  make check            — luacheck + stylua --check"
            echo "  make llscheck         — lua-language-server type check"
            echo "  make api-documentation — generate vimdoc"
            echo "  make coverage-html    — test coverage report"
            echo "  make check-mdformat   — check markdown formatting"
          '';
        };
      });
}

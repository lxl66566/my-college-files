{
  description = "A Nix-flake-based C51 development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            name = "C51";
            buildInputs = with pkgs; [
              sdcc
              xmake
              clang-tools
              python3
              poetry
              minicom
            ];
            shellHook = ''
              xmake f -p mcs51 --toolchain=sdcc -a mcs51 --sdk=/nix/store/5jwp9pyvrrsk617qzlf9gld5ip489x4z-sdcc-4.4.0/
              alias b="xmake && xmake dl"
              echo "xmake sdcc sdk selected!"
            '';
            # shellAlias = '''';
          };
        }
      );
    };
}

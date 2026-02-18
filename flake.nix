{
  description = "PROGEEK loading Plymouth theme";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.stdenv.mkDerivation {
        pname = "progeek-loading-plymouth-theme";
        version = "1.1";

        src = ./plymouth-theme;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/plymouth/themes/progeek_loading
          cp * $out/share/plymouth/themes/progeek_loading
          substituteInPlace $out/share/plymouth/themes/progeek_loading/progeek_loading.plymouth \
            --replace-fail "/usr/" "$out/"

          runHook postInstall
        '';
      };
    });

    overlays.default = final: prev: {
      progeek-loading-plymouth-theme = self.packages.${final.stdenv.hostPlatform.system}.default;
    };
  };
}

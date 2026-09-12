{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib;
let
  cfg = osConfig.programs;
in
{
  config = mkIf cfg.zsh.enable {
    programs.zsh = {
      plugins = with pkgs; [
        {
          name = "fast-syntax-highlighting";
          src = zsh-fast-syntax-highlighting;
          file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        }
        {
          name = "autocomplete";
          src = zsh-autocomplete;
          file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
        }
      ];
      envExtra = ''
        export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/scripts:$PATH"
        ENABLE_CORRECTION="true"
      '';
      initContent =
        let
          general = mkOrder 1000 ''
            if [ -f "$HOME/.zshrc" ]; then; source "$HOME/.zshrc"; fi
            zstyle ':completion:*' remote-access no
          '';
        in
        mkMerge [
          general
        ];
      shellAliases = {
        a2c = ''
          , aria2c \
            --max-connection-per-server=16 \
            --max-concurrent-downloads=5 \
            --min-split-size=1M \
            --file-allocation=falloc \
            --human-readable=true \
            --summary-interval=1 \
            --split=16
        '';
      };
      autosuggestion.enable = true;
      enableCompletion = false;
      enable = true;
    };
  };
}

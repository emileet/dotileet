{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.llama-cpp;
in
{
  config = mkIf cfg.enable {
    services = {
      open-webui = {
        environment = {
          ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION = "False";
          RAG_WEB_LOADER_ENGINE = "bs4";
          WEB_LOADER_ENGINE = "bs4";
          ANONYMIZED_TELEMETRY = "False";
          SCARF_NO_ANALYTICS = "True";
          DO_NOT_TRACK = "True";
        };
        enable = true;
      };
      llama-cpp = {
        package = (pkgs.llama-cpp.override { cudaSupport = true; });
        settings.port = 8881;
      };
      searx = {
        enable = true;
        settings = {
          server.port = 8882;
          search = {
            formats = [
              "html"
              "json"
            ];
          };
          engines = [
            {
              engine = "duckduckgo";
              name = "duckduckgo";
              disabled = false;
            }
          ];
        };
      };
    };
    environment.persistence."/nix/persist/system".directories = [
      "/var/lib/private/open-webui"
      "/var/lib/private/llama-cpp"
      "/var/cache/private/llama-cpp"
    ];
  };
}

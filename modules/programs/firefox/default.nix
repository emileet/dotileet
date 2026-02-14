{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.programs.firefox;
in
{
  config = mkIf cfg.enable {
    programs.firefox = {
      policies = {
        ExtensionSettings = {
          "FirefoxColor@mozilla.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
            installation_mode = "force_installed";
          };

          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };

          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };

          "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
            installation_mode = "force_installed";
          };

          "{c84d89d9-a826-4015-957b-affebd9eb603}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/mal-sync/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        GenerativeAI = {
          Enabled = false;
          Chatbot = true;
          Locked = true;
        };

        DownloadDirectory = "/storage/downloads/downloaded";
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        DisablePocket = true;
      };

      package = pkgs.firefox-devedition;
    };
  };
}

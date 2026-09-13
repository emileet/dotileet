{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.programs;
in
{
  config = mkIf cfg.aria2.enable {
    programs = {
      aria2 = {
        settings = {
          optimize-concurrent-downloads = true;
          stream-piece-selector = "inorder";
          lowest-speed-limit = 0;

          max-connection-per-server = 16;
          max-concurrent-downloads = 5;
          min-split-size = "10M";
          split = 16;

          file-allocation = "falloc";
          piece-length = "1M";
          disk-cache = "64M";

          human-readable = true;
          summary-interval = 1;

          bt-enable-hook-after-hash-check = false;
          bt-request-peer-speed-limit = "12M";
          bt-save-metadata = true;
          bt-max-peers = 128;
          enable-peer-exchange = true;
          enable-dht = true;
          seed-ratio = "0.0";
          seed-time = 0;
        };
        systemd.enable = false;
      };
      zsh.shellAliases = {
        a2bt = "aria2c --max-upload-limit=1K";
        a2c = "aria2c";
      };
    };
  };
}

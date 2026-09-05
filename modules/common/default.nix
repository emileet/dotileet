{ ... }:
{
  time.timeZone = "Australia/Melbourne";
  system.stateVersion = "26.11";

  nix = {
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}

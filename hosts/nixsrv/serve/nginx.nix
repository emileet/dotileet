{ ... }:
{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    appendHttpConfig = ''
      map $scheme $hsts_header {
        https "max-age=31536000; includeSubdomains; preload";
      }

      add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      add_header 'Referrer-Policy' 'origin-when-cross-origin';
      add_header Strict-Transport-Security $hsts_header;
      add_header X-Content-Type-Options nosniff;
      add_header X-Frame-Options DENY;

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    virtualHosts =
      let
        base = locations: {
          inherit locations;
          forceSSL = true;
        };
        proxy =
          port:
          base {
            "/".proxyPass = "http://127.0.0.1:" + toString (port) + "/";
          };
      in
      {
        "emi.gay" = proxy 6984 // {
          useACMEHost = "emi.gay";
          default = true;
        };
        "plsnobully.me" = base { } // {
          useACMEHost = "plsnobully.me";
          globalRedirect = "emi.gay";
        };
      };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@emi.gay";
    certs."emi.gay" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      extraDomainNames = [ "*.emi.gay" ];
      environmentFile = "/nix/secrets/acme/cloudflare";
    };
    certs."plsnobully.me" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      extraDomainNames = [ "*.plsnobully.me" ];
      environmentFile = "/nix/secrets/acme/cloudflare";
    };
  };
}

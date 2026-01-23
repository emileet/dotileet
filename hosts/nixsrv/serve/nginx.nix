{ ... }:
{
  services.nginx = {
    virtualHosts =
      let
        base = locations: {
          inherit locations;
          forceSSL = true;
        };
        proxy =
          config: port:
          base {
            "/" = config // {
              proxyPass = "http://127.0.0.1:" + toString (port) + "/";
            };
          };
        emi-gay = {
          useACMEHost = "emi.gay";
        };
        plsnobully = {
          useACMEHost = "plsnobully.me";
        };
      in
      {
        "emi.gay" =
          emi-gay
          // proxy { } 6981
          // {
            default = true;
          };
        "dl.emi.gay" =
          emi-gay
          // base {
            "/" = {
              basicAuthFile = "/nix/secrets/nginx/auth/dl.emi.gay";
              root = "/vmshare/srv/dl.emi.gay";
              extraConfig = ''
                autoindex_format json;
                autoindex on;
              '';
            };
          };
        "plsnobully.me" =
          plsnobully
          // base { }
          // {
            globalRedirect = "emi.gay";
          };
        "git.plsnobully.me" =
          plsnobully
          // proxy {
            extraConfig = "gzip off;";
          } 6985;
        "pod.plsnobully.me" =
          plsnobully
          // proxy {
            extraConfig = ''
              client_max_body_size 800M;
              gzip off;
            '';
          } 5050;
      };

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    appendHttpConfig = ''
      map $scheme $hsts_header {
        https "max-age=31536000; includeSubdomains; preload";
      }

      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      add_header 'Referrer-Policy' 'origin-when-cross-origin';
      add_header Strict-Transport-Security $hsts_header;
      add_header X-Content-Type-Options nosniff;
      add_header X-Frame-Options DENY;

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    enable = true;
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

# nginx_common Features

- create DH-parameters
- create a config-snippet (which can be included in vhosts) to ensure SSL/TLS-parameters are consistent in all vhosts. This includes protocolls, ciphers, ocsp stapling and HSTS


    ssl on;
    ssl_certificate /etc/letsencrypt/live/$FQDN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$FQDN/privkey.pem;

    include /etc/nginx/snippets/tls-hardening.conf;




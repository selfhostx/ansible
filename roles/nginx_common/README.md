# nginx_common Features

- create DH-parameters
- create a config-snippet (which can be included in vhosts) to ensure SSL/TLS-parameters are consistent in all vhosts. This includes protocolls, ciphers, ocsp stapling and HSTS


    ssl_certificate /etc/letsencrypt/live/$FQDN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$FQDN/privkey.pem;

    include /etc/nginx/snippets/tls-hardening.conf;

# Variables

see [defaults/main.yml](defaults/main.yml)

| Variable | Default | Description |
|---|---|---|
| `nginx_ssl_private_directory_owner` | `root` | owner of `nginx_ssl_private_directory` |
| `nginx_ssl_private_directory_group` | `""` | empty: `ssl-cert` if the group exists, else `root` |
| `nginx_ssl_private_directory_mode` | `""` | empty: `0710` with a group other than root, else `0700` |
| `nginx_ssl_stapling_enable` | `true` | use `false` with Let's Encrypt certificates, they have no OCSP URL since 2025 |

`ssl-cert` with `0710` is the Debian default. PostgreSQL with `ssl = on` needs it to read the snakeoil key.

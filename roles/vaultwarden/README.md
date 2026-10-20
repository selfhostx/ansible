Vaultwarden
===========

Deploys vaultwarden via Docker Compose with an nginx reverse proxy vhost.

Additional manual configuration will be required at `https://{{ vaultwarden_hostname }}/admin` !

Settings saved in the admin panel are written to `data/config.json` and override the `.env` rendered by this role.

Requirements
------------

* Docker with compose plugin (e.g. `geerlingguy.docker`)
* nginx installed (e.g. `selfhostx.ansible.nginx_common`), the role only manages the vhost
* TLS certificates
* collection `community.docker`
* some way of sending mail

Role Variables
--------------

| Variable | Class | Default | Description |
|---|---|---|---|
| `vaultwarden_admin_token` | recommended | - | admin token (-> vault), admin panel disabled if unset |
| `vaultwarden_hostname` | recommended | fqdn | hostname of the instance |
| `vaultwarden_version` | recommended | `latest` | image tag, `latest` is pulled on every run |
| `vaultwarden_env_extra` | recommended | `""` | additional environment |
| `vaultwarden_database_url` | optional | `""` | MySQL/PostgreSQL URL, empty = SQLite |
| `vaultwarden_admin_token_argon2_prehashed` | optional | - | argon2 PHC string instead of `vaultwarden_admin_token` |
| `vaultwarden_nginx_ssl_certificate` | optional | letsencrypt path | TLS fullchain |
| `vaultwarden_nginx_ssl_certificate_key` | optional | letsencrypt path | TLS privkey |
| `vaultwarden_nginx_config_src_dir` | optional | `/etc/nginx/conf.d` | where the vhost is rendered |
| `vaultwarden_nginx_config_dst_dir` | optional | `/etc/nginx/conf.d` | where it is enabled (symlink if different) |
| `vaultwarden_nginx_client_max_body_size` | optional | `525M` | max upload size |
| `vaultwarden_backup_enable` | optional | `false` | daily SQLite + data backup |
| `vaultwarden_backup_dir` | optional | `/var/backups/vaultwarden` | backup target |
| `vaultwarden_backup_retention_days` | optional | `14` | backup retention |

For more vars see [defaults/main.yml](defaults/main.yml).

Debian layout with sites-available / sites-enabled:

    vaultwarden_nginx_config_src_dir: /etc/nginx/sites-available
    vaultwarden_nginx_config_dst_dir: /etc/nginx/sites-enabled

Database
--------

SQLite (default) is fine for multiple users on a single instance. Do not put `data/` on NFS/CIFS.
Use MySQL/PostgreSQL via `vaultwarden_database_url` for HA or an existing central database.
Do not expose the database on `0.0.0.0` with user host `%`.

Backup
------

With `vaultwarden_backup_enable: true` a cronjob writes `sqlite3 .backup` dumps plus a tarball of
`data/` (attachments, sends, `rsa_key*`, `config.json`) to `vaultwarden_backup_dir`.
Only active without `vaultwarden_database_url`.

Upgrade from older versions
---------------------------

* Compose v1 (`docker-compose`) is no longer used, the role requires the `docker compose` plugin.
* Removed variables: `vaultwarden_git_src`, `vaultwarden_install_docker_compose_via_pip`,
  `vaultwarden_user_docker_compose_cmd`, `vaultwarden_docker_registy`.
* The vhost moves to `conf.d`, the old one in sites-available/sites-enabled is removed.
* `/opt/vaultwarden/repo` is no longer used and can be deleted.
* Pre-hashed tokens with `$$` keep working.

Example Playbook
----------------

See [vaultwarden-example.yml](vaultwarden-example.yml).

        - name: Install vaultwarden
          hosts: vaultwarden.DOMAIN.TLD
          become: true
          roles:
            - { role: geerlingguy.docker, tags: docker }
            - { role: selfhostx.certbot, tags: certbot }
            - { role: selfhostx.ansible.nginx_common, tags: nginx_common }
            - { role: selfhostx.ansible.vaultwarden, tags: vaultwarden }
          vars_files:
            - YOUR-vault.yml
            # includes vaultwarden_admin_token

License
-------

BSD-3-Clause


Author Information
------------------

Tim Jonathan Heske <mail@heske.biz>
Stefan Schwarz <st@stefanux.de>

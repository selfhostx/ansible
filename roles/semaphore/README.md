# Ansible UI Semaphore

Ansible role to install and configure the [Ansible UI Semaphore](https://github.com/ansible-semaphore/semaphore) (minimum supported version: 2.9.37).

## Requirements

None. But for a production environment you should install a webserver as proxy for ssl termination (role is prepared for nginx).

## Example playbook

````yaml
- hosts: all
  become: yes

  roles:
  - semaphore

  vars:
    semaphore_addn_config:
      email_alert: true
      email_sender: "semaphore@example.com"
````

### Using an existing database/mariadb

Just set `semaphore_mysql_install: false` and provide the credentials `semaphore_mysql_*`.

## Role variables

None of the variables below are required.

| Variable                 | Default   | Comment |
| :---                     | :---      | :---    |
| `semaphore_version`      | latest available version  | the version to download (example: 2.8.77), also see `semaphore_download_url` and `semaphore_download_checksum` |
| `semaphore_mysql_install` | `true`   | whether to install mysql on the host, installs with the password `mysql_root_password` |
| `semaphore_mysql_create_db` | `true` | whether to create the mysql db and user |
| `semaphore_db_host`:`semaphore_db_port` | `127.0.0.1`:`3306` | the mysql host |
| `semaphore_db_name`     | semaphore | the mysql database |
| `semaphore_db_user`   | semaphore | the mysql user |
| `semaphore_db_password` | semaphore | the mysql user password |
| `semaphore_user`         | semaphore | the user and systemd identifier semaphore runs as |
| `semaphore_listen_ip`     | `127.0.0.1`    | the IP semaphore binds to |
| `semaphore_port`   | `3000`    | the port semaphore binds to |
| `semaphore_path`         | /opt/semaphore | destination for the binary |
| `semaphore_config_path`  | /etc/semaphore/semaphore.json | config file |
| `semaphore_default_user` | admin | login name of the default user |
| `semaphore_default_user_make_admin` | true | make default user admin |
| `semaphore_default_user_name` | `semaphore_default_user` | his human readable name |
| `semaphore_default_user_password` | admin | the password |
| `semaphore_default_user_mail` | admin@example.com | and mail adress |
| `semaphore_default_user_password` | `admin` | change to a secure value! |
| :---                     | :---      | :---    |
| `semaphore_nginx_deploy_reverseconfig` | false | set to true to enable nginx |
| `semaphore_nginx_config_filename` | `semaphore` | filename of nginx vhost-config |
| `semaphore_nginx_ssl_certificate` | `/etc/letsencrypt/live/{{ semaphore_hostname }}/fullchain.pem` | path to tls certificate |
| `semaphore_nginx_ssl_certificate_key` | `/etc/letsencrypt/live/{{ semaphore_hostname }}/privkey.pem` | path to tls key |

For all options see [defaults/main.yml](defaults/main.yml)

## Demo/Development

Role forked from https://github.com/morbidick/ansible-role-semaphore

changes from forked roles are mostly on vars, added nginx reverse-config (see this [commit](https://github.com/morbidick/ansible-role-semaphore/commit/f1720b0ea88931c780c05bf4396f29b12786cd33) or this [comparison](https://github.com/morbidick/ansible-role-semaphore/compare/main...stefanux:ansible-role-semaphore:main)) for details.
will backport upstream changes if useful.

Maybe not included latest features from semaphore in config template, if you see missing keys or errors: please open a issue / PR.

Molecule is useable for testing (not used atm), the webinterface of the centos machine will be exposed and can be used as demo.

* run `molecule converge`
* open your browser at [127.0.0.1:3000](http://127.0.0.1:3000)
* and login with user and password `admin`.

## License

MIT


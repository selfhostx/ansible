# ansible-netbox

Ansible role to install/configure NetBox

based on https://github.com/mrlesmithjr/ansible-netbox 
- check on latest version via githib-API (and ability to choose latest as netbox_version)
- without supervisord, systemd-unit instead
- additional systemd rq and housekeeping unit + timer
- nginx config with https (you can use nginx_common too)

Note: current version of netbox (tested: 3.6.3) will not run on centos8 (rhel8) ("could not find a version that satisfies the requirement bleach==6.0.0") and debian10 ("Could not find a version that satisfies the requirement Django==4.2.5") due to /opt/netbox/netbox/requirements.txt .

## Requirements

This role won't:
- create database
- install redis
but the [playbook.yml](playbook.yml) contains (tested) examples how to do it.

For any required Ansible roles, review:
[requirements.yml](requirements.yml)


## Role Variables

see [defaults/main.yml](defaults/main.yml) for full list of variables, most important:

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| netbox_hostname | d | v | yes | defaults to ansible_fqdn |
| netbox_allowed_hosts | a (comma-seperated) list of valid fully-qualified domain names (FQDNs) and/or IP addresses that can be used to reach the NetBox service. example: "host1.domain.tld, host2.domain.tld" (is used for [CSRF_TRUSTED_ORIGINS](https://docs.djangoproject.com/en/4.2/ref/settings/#std:setting-CSRF_TRUSTED_ORIGINS)) | string | yes | var: netbox_hostname |
| netbox_superuser_username | username of admin-user | string | yes | netbox |
| netbox_superuser_password | password of admin-user | string | yes | netbox |
| netbox_superuser_email | email for admin-user | string | yes | netbox@{{ netbox_pri_domain }} |
| netbox_db_host | host of netbox database | string | yes | localhost |
| netbox_db_user | user of netbox database | string | yes | netbox |
| netbox_db_password | password of netbox database | string | yes | netbox |
| netbox_db | name of the netbox database | string | yes | netbox |
| netbox_nginx_deploy_reverseconfig | use our nginx-config (set to "false" to use other reverse-proxies) | boolean (true, false) | no | true |
| netbox_nginx_ssl_certificate | path to (combined chain + cert) certificates for nginx | string | yes | /etc/letsencrypt/live/{{ netbox_hostname }}/fullchain.pem |
| netbox_nginx_ssl_certificate_key | path to keyfile for nginx | string | yes | /etc/letsencrypt/live/{{ netbox_hostname }}/privkey.pem |

## Dependencies

## Example Playbook

[playbook.yml](playbook.yml)

## License

MIT

## Author Information

Stefan Schwarz
Larry Smith Jr.

# ansible-netbox

Ansible role to install/configure NetBox

based on https://github.com/mrlesmithjr/ansible-netbox 
- check on latest version via githib-API (and ability to choose latest as netbox_version)
- without supervisord, systemd-unit instead
- additional systemd rq and housekeeping unit + timer
- nginx config with https (you can use nginx_common too)

Note: current version of netbox (tested: 3.6.3) will not run on centos8 (rhel8) ("could not find a version that satisfies the requirement bleach==6.0.0") and debian10 ("Could not find a version that satisfies the requirement Django==4.2.5") due to /opt/netbox/netbox/requirements.txt .

## Requirements

For any required Ansible roles, review:
[requirements.yml](requirements.yml)

## Role Variables

[defaults/main.yml](defaults/main.yml)

## Dependencies

## Example Playbook

[playbook.yml](playbook.yml)

## License

MIT

## Author Information

Stefan Schwarz
Larry Smith Jr.

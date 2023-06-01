Purpose and principles
======================

This collection should enable self-hosters full control of their infrastructure and data (GDPR-focus when external services are used).
It will be OSS forever and everyone should be able to integrate it into their infrastructure (or product).
We do not re-invent the wheel, if there is a good role or collection somewhere else: we won`t duplicate it (unless important features are missing).

supported distributions:
  - Debian (all supported versions)
  - Ubuntu (supported LTS-Versions)
  - Redhat-based distribution (permanent - if maintainer is found - or best-effort-basis)

2DO in general:
  - CI (travis, gitlab runner, ...?)


Roles
-----

 Roles (includes recommendations)                             | Description 
--------------------------------------------------------------|-------------------
[apache](https://github.com/selfhostx/ansible-role-apache)    | apache webserver
[bacula](roles/bacula)                                        | backup system
[baserole](roles/baserole)                                    | basic role for (new) systems
[certbot](https://github.com/selfhostx/ansible-role-certbot)  | certbot (letsencrypt)
[dokuwiki](roles/dokuwiki)                                    | dokuwiki (PHP+file-based wiki)
[libvirt](roles/libvirt)                                      | simple virtualization via libvirt+KVM
[mailrelay](roles/mailrelay)                                  | relay mails via postfix
[mattermost](roles/mattermost)                                | mattermost (instant messenger)
[nginx (common)](roles/nginx_common)                          | nginx common role
[PHP](https://github.com/geerlingguy/ansible-role-php)        | PHP-role (geerlingguy)
[samba (standalone)](roles/samba_standalone)                  | samba fileserver (standalone, without AD)
[vaultwarden](roles/vaultwarden)                              | vaultwarden is a good zero-knowledge passwordmanager (compatible to bitwarden)
[zabbix_checks](roles/zabbix_checks)                          | a couple of useful templates and userparameters for zabbix (monitoring system)

more planned, see [Roadmap](ROADMAP.md)


Requirements
------------

minimum ansible version: 2.10

Role requirements
-----------------

good documentation (preferably a link to a basic user documentation too)

example playbook

proper code formatting (ansible-lint)

classify variables per role
- required (execution fails if not defined)
- recommended (common customization)
- optional (less commonly changed)

dependencies
- other roles
- neede pip-modules on target

definition of variables and dependencies (see above) need to be machine-readable to enable automation/custom GUIs) -> 2DO define fileformat!

python3 is required

active maintainers!


Dependencies
------------

FIXME Link requirements-file
FIXME list all include_role in requirements-file


License
-------

GPLv3 (unless explicitly stated otherwise)

FAQ
---

Q: Why not plain shellscripts?
A: Shellscript have full flexibility ... but you`ll need to implement everything yourself:
- templating with condition and variable expansion
- handlers (run action when certain condition are met, i.e. restart service only when config is changed via template)
- are not idempotent (it does not have the same result when you run it again)
- re-implement code stuff that is already available today (ansible galaxy has tons of code)
- validate config for services that offer it (i.e. prevent broken sudo configs ...)
- automated/unattended run (installations are not always done interactivly done by a humans!)
- check-mode (-C) has the ability to show what changes would have been applied
- error-handling: try to trap errors with pipefail ... that blows up code massively. Example for error-handling in bash (how many of your scripts does implement something similar?):
~~~
set -eo pipefail

cleanup() {
# remove temp files
}
trap cleanup 0

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    error_message="Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    error_message="Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  echo "$error_message" # for cron
  exit "${code}"
}
trap 'error ${LINENO}' ERR
~~~


similiar projects
-----------------

ansible-collectionm:
- https://github.com/tteck/Proxmox
- debops https://docs.debops.org/en/stable-3.0/
- https://github.com/JGoutin/ansible_home
- https://github.com/davestephens/ansible-nas
- https://github.com/sacredheartsc/selfhosted

app-stores.
- cloudron: https://www.cloudron.io/store/index.html
- yunohost: https://yunohost.org/en/apps

app-installer:
- bitnami (aquired by vmware)
- turnkey (own scripts)
- pikapods (based on docker)

organizations supporting hosting:
- https://docs.codeberg.org/getting-started/what-is-codeberg/#what-is-codeberg-e.v.%3F

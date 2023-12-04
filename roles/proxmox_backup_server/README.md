Proxmox Backup Server (pbs)
===========================

This role sets up Proxmox Backup Server and client.


Requirements
------------

None

community.crypto for fingerprint.


Role Variables
--------------

* `pbs_server_repo`: Should be either `{{ pbs_no_subscription_repo }}` (default) or `{{ pbs_enterprise_repo }}` .

Dependencies
------------

None


Example Playbook
----------------

[example_playbook.yml](example_playbook.yml)


License
=======

GPL-3.0-or-later


Author Information
==================

selfhostx

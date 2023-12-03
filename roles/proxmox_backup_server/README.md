pbs
===

This role sets up Proxmox Backup Server and client

Requirements
------------

None

Role Variables
--------------

* `pbs_server_repo`: Should be either `{{ pbs_no_subscription_repo }}` (default) or `{{ pbs_enterprise_repo }}` .

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

Author Information
------------------

Selfhostx

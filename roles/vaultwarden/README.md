Vaultwarden
===========

Sets up vaultwarden.

Additional manual configuration will be required at `https://{{ vaultwarden_hostname }}/admin` !

Requirements
------------

Further requirements:

* tls-certificates should be deployed
* some way of sending mail

Role Variables
--------------

* vaultwarden_admin_token: Admin secret for admin interface (-> vault) REQUIRED!
* vaultwarden_hostname: Hostname of instance (defaults to inventory-name)
* vaultwarden_version: Version of Vaultwarden according to `https://github.com/dani-garcia/vaultwarden/releases`
* vaultwarden_nginx_ssl_certificate: Path to TLS fullchain
* vaultwarden_nginx_ssl_certificate_key: Path to TLS privkey

for more vars see [defaults/main.yml].

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

        - name: Install vaultwarden
          hosts: vaultwarden.DOMAIN.TLD
          roles:
            # - { role: selfhostx.ansible.baserole, tags: baserole }
            - { role: geerlingguy.git, tags: git }
            - { role: geerlingguy.pip, tags: pip }
            - { role: geerlingguy.docker, tags: docker }
            # - { role: selfhostx.certbot, tags: certbot }
            # - { role: selfhostx.ansible.nginx_common, tags: nginx_common }
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

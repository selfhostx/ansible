Rspamd role
===========

rspamd role for installation via packages.
tasks taken from: https://github.com/ubermail/ubermail, package source from role securcom.repo_rspamd .


Requirements
------------

see playbook-section for examples!

what do your need on the system?
- redis (like geerlingguy.redis)
- postfix running and configured (like selfhostx.ansible.mailrelay)
- postfix milter config for rspamd:
- recursive resolver (blacklist queries often have limits which make public nameservers useless), sugesting powerdns recursive (role: powerdns.pdns_recursor)

~~~
# smtpd_milters = unix:/var/lib/rspamd/rspamd.sock
# -> permissions!
# or for TCP socket:
smtpd_milters = inet:localhost:11332

# skip mail without checks if something goes wrong
milter_default_action = accept

# 6 is the default milter protocol version;
# prior to Postfix 2.6 the default protocol was 2.
milter_protocol = 6
~~~

optional:
- certbot (certificate for admin-gui and postfix)


Role Variables
--------------

see [defaults/main.yml](defaults/main.yml)


Example Playbook
----------------

simple playbook:
~~~
    - hosts: servers
      roles:
        - { role: selfhostx.ansible.rspamd, tags: rspamd }
~~~

[complex playbook](playbook-example.yml)


License
-------

GPL-3.0 license (partly BSD)

Author Information
------------------

Stefan Schwarz <st@stefanux.de> (merging and extending both roles)
https://github.com/ubermail/ubermail (main part configuration)
Peter Hudec (@hudecof) https://github.com/securCom/ansible-role_repo-rspamd (BSD license)

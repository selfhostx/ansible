Ansible Role: Dokuwiki
=========

Build status for this role: [![Build Status](https://travis-ci.org/PeterMosmans/ansible-role-dokuwiki.svg)](https://travis-ci.org/PeterMosmans/ansible-role-dokuwiki)


This role installs, configures, hardens and/or upgrades Dokuwiki on a server.
The main focus is on provisioning Dokuwiki instances in a repeatable and secure
fashion. It does not install a webserver by itself, but it can add and enable an
Apache configuration file (which is included as template in the role).


Requirements
------------

A webserver having PHP installed, e.g. by using PeterMosmans.apache2


Role Variables
--------------

Available variables are listed below, along with default values. The default
values are specified in `default/main.yml`.

**dokuwiki_configure_apache2**: When true, will deploy an Apache configuration
(`dokuwiki.conf.j2`) to Apache, and enable the site. By default, the variable is
undefined (false).


**dokuwiki_name**: The 'internal' name of the dokuwiki, which is e.g. used for
Apache logfiles and the cleanup cronjob. (when `dokuwiki_configure_apache2` is
true). This allows the Ansible role to be used for multiple Dokuwiki sites on
the same server. Default:
```
dokuwiki_name: dokuwiki
```


**dokuwiki_source**: The URL where the (latest) version of Dokuwiki can be
found. By default, it uses the official Dokuwiki source.
```
dokuwiki_source: https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
```


**dokuwiki_base**: The local path where Dokuwiki will be installed.
```
dokuwiki_base: /var/www/html
```


**dokuwiki_group**: The group owning the Dokuwiki files.
```
dokuwiki_group: www-data
```


**dokuwiki_plugins**: A list of name / source pairs, with plugins to
automatically install. The sources need to point to tar or .tgz sources (e.g.).
Example:
```
 - name: pagelist
   src: https://github.com/dokufreaks/plugin-pagelist/tarball/master
```


**dokuwiki_plugins_remove**: A list of plugins to automatically remove upon
installation or upgrade.
Default:
```
dokuwiki_plugins_remove:
  - name: authad
  - name: authldap
  - name: authmysql
  - name: authpdo
  - name: authpgsql
  - name: info
  - name: popularity
```


**dokuwiki_provision**: When true, apply configuration templates to provision
Dokuwiki. If not specified or false, Dokuwiki will be unprovisioned, a default
installation. See below in the provisioning chapter which variables can be used
in the configuration templates. Note that when this variable is true, it will
(re-)template and overwrite the current Dokuwiki configuration.

The following configuration files are templated:
- `/conf/acl.auth.php`
- `/conf/local.php`
- `/conf/plugins.local.php`
- `/conf/users.auth.php`

Example:
```
dokuwiki_provision: true
```


**dokuwiki_savedir**: The directory where all files (content) will be stored.
```
dokuwiki_savedir: /var/www/html/data
```


**dokuwiki_templates**: A list of name / source pairs, with templates to
automatically install. The sources need to point to tar or .tgz sources (e.g.).
Example:
```
dokuwiki_templates:
 - name: bootstrap3
   src: https://github.com/LotarProject/dokuwiki-template-bootstrap3/tarball/master
```


**dokuwiki_user**: The user owning the Dokuwiki files.
```
dokuwiki_user: root
```


## Provisioning
The following variables will be used in the configuration templates
(`local.php.j2`, `users.auth.php.j2`), and therefore will only be applied if
`dokuwiki_provision` is set to `true`.


**dokuwiki_acl_all**: The ACL bits for the default (@ALL) group. By default,
only logged on users are allowed access (0).


**dokuwiki_acl_user**: The ACL bits for the user (@user) group. By default,
users have upload, create, edit, and read permissions (8).


**dokuwiki_disableactions**: Which actions to disable. By default, nothing
is disabled.


**dokuwiki_title**: The Dokuwiki title


**dokuwiki_local**: A list of name / value configuration pairs to be added to
the `local.php` configuration file.
Example:
```
dokuwiki_local:
  - name: "['passcrypt']"
    value: 'bcrypt'
```
This will result in adding the following string to `/conf/local.php`:
```
$conf['mytemplate'] = 'myvalue';
```


**dokuwiki_users**: A list of users, containing the following name / value pairs:
```
- login: login
- hash: password hash
- name: full name
- email: email address
- groups: comma separated list of groups
```

Example:
```
dokuwiki_users:
- login: admin
  hash: "$2y$05$Nr3wFqH54gcdhxPK9easseLSVwLAnLTD2flYmQbAbCVIiiTU4mCjS"
  name: Administrator
  email: admin@admin
  groups: admin,user
```

This will result in adding the user admin to Dokuwiki, with the bcrypted password `admin`.

Dependencies
------------

None.


Example Playbook
----------------
```
- hosts: all
  become: yes
  become_method: sudo
  roles:
  - role: PeterMosmans.dokuwiki
  vars:
    dokuwiki_base: /var/www/html
    dokuwiki_configure_apache2: true
    dokuwiki_plugins:
      - name: tag
        src: https://github.com/dokufreaks/plugin-tag/tarball/master
      - name: pagelist
        src: https://github.com/dokufreaks/plugin-pagelist/tarball/master
    dokuwiki_plugins_remove:
      - name: authad
      - name: authldap
      - name: authmysql
      - name: authpdo
      - name: authpgsql
      - name: info
      - name: popularity
    dokuwiki_preconfigure: true
    dokuwiki_savedir: /var/www/html/data
    dokuwiki_template: bootstrap3
    dokuwiki_templates:
      - name: bootstrap3
        src: https://github.com/LotarProject/dokuwiki-template-bootstrap3/tarball/master
    dokuwiki_users:
      - login: admin
        hash: "$2y$05$Nr3wFqH54gcdhxPK9easseLSVwLAnLTD2flYmQbAbCVIiiTU4mCjS"
        name: Administrator
        email: admin@admin
        groups: admin,user
```
This example will install Dokuwiki to `/var/www/html`, and use `/var/www/html/data` as data directory.
It will install the plugins `tag` and `pagelist`, and remove the plugins `authad`, `authldap`, `authmysql`, `authpdo`, `authpgsql`, `info` and `popularity`.
It will install and use the `bootstrap3` theme, and grant the user `admin` with the password `admin` access to the wiki.
Moreover, it will configure and enable the Apache site.


License
-------

GPLv3


Author Information
------------------

Created by Peter Mosmans. Suggestions, feedback and pull requests are always
welcome.

Contributions by @onny @n0emis @stefanux

Original: https://github.com/PeterMosmans/ansible-role-dokuwiki

# ansible Installation

## important links
===============

- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#ansible-variable-precedence


## concepts

- inventory: list of hosts ansible can manage (YAML or ini-style)
- playbook: YAML file contains vars, tasks, handlers, role/collection-definition: the starting point of most ansible runs
- tasks: defintions what should be done via ansible-modules with parameters, conditions etc.
- roles: library of tasks
- collections: library of roles
- handlers: special tasks that run asynchronous when triggered (via notify)
- templates: jinja2-definitions (usually .j2 file-extension) how files will look like (templated via templat-module)
- modules: library of functions task can use (internally Python-Code)
- ad-hoc-commands (run simple commands on hosts, groups): example: `ansible -i hosts -m shell -a "uname -a" all`
- facts: special variables the "setup"-module gathers on hosts (like operating system etc.)
- tags: specific keywords on tasks (allowing run only needed tasks)
- vault: encrypted files for secrets

## commands:
- ansible-playbook: run playbook
- ansible-vault: managed vaults
- ansible-lint: syntax-check (will not catch logic errors like trying to use undefined variables or typos in var-names): `ansible-lint my-playbook.yml`

german version: https://www.stefanux.de/wiki/doku.php/software/ansible#begriffe


## Install

ensure you are able to switch ansible versions independently from distribution. pip (or specific pip3 since python2 is deprecated) is a good solution:

```
# debian:
sudo apt install python3-pip git
sudo -H pip3 install ansible ansible-lint
```

get the requirements for this collection (if not already cloned): `wget https://raw.githubusercontent.com/selfhostx/ansible/main/requirements-selfhostx.yml`

install required roles and collections locally (including this collection) to ~/.ansible/roles (or ~/.ansible/collections):

```
ansible-galaxy install -r requirements-selfhostx.yml --ignore-errors
ansible-galaxy collection install -r requirements-selfhostx.yml
```


## editor setup

set your editor to convert tabs into 2 spaces.

vim
```
set tabstop=2
set shiftwidth=2
set expandtab
# autocmd Filetype yml setlocal tabstop=2
```


nano:
```
set tabsize 2
set tabstospaces
```

## ansible.cfg

see https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html for more information

```
[defaults]
host_key_checking=False
# format of string {{ ansible_managed }} available within Jinja2:
ansible_managed = Ansible managed: {file}

# vault_file=vault.yml
# ask_vault_pass = True 
# or use: --ask-vault-pass
# vault_password_file must be outside the main git-repo (chmod 600 this file!) and user/system independent:
# vault_password_file = /etc/ansible-vault-password

ansible_python_interpreter: /usr/bin/python3

inventory=inventory_SAMPLE

# ssh-config:
# ansible_port=22
# remote_user=root

[privilege_escalation]
become = True
become_method=sudo
```


# ansible execution


ansible-playbook my-playbook.yml

| Parameter for ansible-playbook | Description |
| ----------- | ----------- |
| -C | check-mode: Durchlauf ohne Änderungen |
| -D | -> diff-mode: zeigt Änderungen
| -l $host (or $group) | limit runs to host or group
| --tags $tag or --skip-tags $tag| run only specific tasks with(out) the specified tag |

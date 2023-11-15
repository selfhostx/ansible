
Description
===========


This role creates fully automated computer instances (VMs) 

supported virtualization plattforms:
- proxmox (no matter if on-premise or co-location, single-server or cluster)
- VmWare (planned)
- hetzner (planned)
using cloud-init (datasource: config-drive, other will follow, maybe nocloud https://cloudinit.readthedocs.io/en/latest/reference/datasources.html)
- support bootparameters for grub
- network config (+ DNS) depending on choice of the distribution cloud-image (ifupdown/netplan/networkmanager)
- injecting pubkeys before network is even up
- executing commands
- update packages, reboot ... and so on

networking (IPv4 AND/OR IPv6)
- next free from given prefix (via query of IPAM solution) netbox (or infoblox in the future)
- or manual values (no IPAM)
- or disabled (when v4 or v6 is not needed)

creates DNS-entries, currently implemented:
- hetzner
- inwx


Example playbooks
=================

[playbook-create-cloud-init-template.yml](playbook-create-cloud-init-template.yml)
[playbook-compute-instance-interactive.yml](playbook-compute-instance-interactive.yml)

Vars
====

# Required/most important vars:

# hostname (FQDN):
compute_instance_hostname: "FQDN"

# distribution (values: debian, ubuntu, centos):
compute_instance_distribution: "debian"

# name of the template-VM to clone from (cloud image)
compute_instance_cloudinit_image: "template-cloudinit-deb12-latest"

# memory (max.) for VM (in MB), example with 2G:
compute_instance_memory_max: 2048

# number of CPU cores (example: 2):
compute_instance_cores: 2

# disk size in GB (example: 20G):
compute_instance_disksize: 20

# name of target storage (proxmox usually has local" or "local-zfs)
compute_instance_storage: "local-zfs"

# network/IP for new instance, valid choices:
# - name of network from dict network_prefix_list (ipam will choose next free IP)
# - a specific IP with CIDR (like 192.168.178.33/24)
# - "no" -> no v4 (or v6) networking
#
Examples:

compute_instance_ip_v4: "home_network_v4" <- from "network_prefix_list"
# OR:
compute_instance_ip_v4: "192.168.178.33/24"
# deactivate IPv6:
compute_instance_ip_v6: "no"

# enable creation of DNS records:
compute_instance_dns_create_records_enable: true

# valid choices: proxmox, vmware (stub)
compute_instance_virtualization_provider: proxmox
# valid choices: netbox, infobloxx (stub)
compute_instance_ipam_provider: netbox
# valid choices: hetzner, inwx
compute_instance_dns_provider: hetzner

[more vars in defaults/main.yml](defaults/main.yml)


REQUIREMENTS
============

on controller:
- ansible-galaxy collection install community.general inwx.collection community.dns
- https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_proxmox_module.html

on target:
- pip3 install netaddr proxmoxer pynetbox

on virtualization host:
- VM-template on proxmox with name of var "compute_instance_cloudinit_image".

role is able to install requirements on target.


License
=======

GPL-3.0-or-later


Author Information
==================

Stefan Schwarz <st@stefanux.de>


Description
===========


This role creates fully automated computer instances (VMs).

supported virtualization plattforms:
- **proxmox** (no matter if on-premise or co-location, single-server or cluster)

**cloud-init** (datasource: config-drive, other will follow, maybe nocloud https://cloudinit.readthedocs.io/en/latest/reference/datasources.html)
- support bootparameters for grub
- network config (+ DNS) depending on choice of the distribution cloud-image (ifupdown/netplan/networkmanager)
- injecting pubkeys before network is even up
- executing commands
- update packages, reboot ... and so on

**networking** (IPv4 AND/OR IPv6)
- manual values (no IPAM)
- or next available IP from given prefix (via query of IPAM solution like netbox)
- or disabled (when v4 or v6 is not needed)

creates **DNS-entries**, currently implemented:
- hetzner
- inwx


Example playbooks
=================

- [playbook-compute-instance-manual.yml](playbook-compute-instance-manual.yml
- [playbook-compute-instance-netbox.yml](playbook-compute-instance-netbox.yml)
- [playbook-create-cloud-init-template.yml](playbook-create-cloud-init-template.yml)


Variables
=========

Required/most important vars:

- **hostname (FQDN)** -> `compute_instance_hostname: "FQDN"`
- **distribution** (values: debian, ubuntu, centos) -> `compute_instance_distribution: "debian"`
- **name of** the **template-VM** to clone from (cloud image) -> `compute_instance_cloudinit_image: "template-cloudinit-deb12-latest"`
- **memory** (max.) for VM (in MB), example with 2G -> `compute_instance_memory_max: 2048`
- number of **CPU cores** (example: 2vcpu) -> `compute_instance_cores: 2`
- **disk size** in GB (example: 20G) -> `compute_instance_disksize: 20`
- name of target **storage** (proxmox usually has local" or "local-zfs) -> `compute_instance_storage: "local-zfs"`
- **network/IP** for new instance:
   - no IPAM: `compute_instance_ipam_provider: manual` (see: [playbook-compute-instance-manual.yml](playbook-compute-instance-manual.yml))
     - IPv4 (CIDR-notation):`compute_instance_ip_v4: 192.168.178.123/24` OR `compute_instance_ip_v4: "no"`
     - IPv6 (CIDR-notation): `compute_instance_ip_v6: 1:2:3:4::abc/64`
     - Gateway IPv4: `compute_instance_gateway_v4: 192.168.178.1` OR `compute_instance_ip_v6: "no"`
     - Gateway IPv6: `compute_instance_gateway_v6: 1:2:3:4::1`
     - Name of the interface/bridge your instance will connected to: `compute_instance_bridge: vmbr0`
   - IPAM netbox: `compute_instance_ipam_provider: netbox` (see: [playbook-compute-instance-netbox.yml](playbook-compute-instance-netbox.yml))
     - IPv4 same options as "no IPAM", additional option: name of network (example: "home_network_v4" from dict `network_prefix_list`: `compute_instance_ip_v4: "home_network_v4"` (IPAM will choose next free IP from that prefix)
     - IPv6 same options as "no IPAM", additional option. example: `compute_instance_ip_v6: "home_network_v6"`
- **IPAM solution** (valid choices: netbox, infobloxx (stub): `compute_instance_ipam_provider: netbox`
- **Virtualization plattform**, valid choices: proxmox, vmware (stub): `compute_instance_virtualization_provider: proxmox`
- **DNS**, enable creation of DNS records: `compute_instance_dns_create_records_enable: true`
  - dns provider (valid choices: hetzner, inwx) -> `compute_instance_dns_provider: hetzner`

**[more vars in defaults/main.yml](defaults/main.yml)**


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

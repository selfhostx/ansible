# ansible-role-bacula

This Role installs any component of the backup system "bacula" AND configures everything (including agent configs like filesets for all systems) so you can use bacula gitops-style (aka do everything from ansible).


## quick bacula introduction

| Component | function | variable (ansible-tag) |
| ------------- |:-------------:| -----:|
| bacula-director (dir) | central management, coordination on other components | bacula_dir_role (bacula-dir) |
| bacula-storage daemon (sd) | controls the writing device(s) | bacula_sd_role (bacula-sd) |
| bacula-console | management console, connects to bacula-dir | bacula_console_role (bacula-console) |
| bacula-file daemon (fd) | agent on target system | bacula_fd_role (bacula-fd) |

see the notes on firewalling: https://www.bacula.org/9.6.x-manuals/en/problems/Dealing_with_Firewalls.html

## Requirements
- installed database-server (mysql or pgsql) on director

## Limitations

Currently only tested on mysql / mariadb and Ubuntu/Debian in LTS-Versions.

## Using Official Bacula Repository (Bacula 10+)

### Overview

Starting with Bacula 10, official packages require registration and GPG key verification. This role supports both:
- **Distribution packages** (default, older Bacula versions from distro repos)
- **Official Bacula repository** (newer versions with free registration)

### When to Use Official Repository

Use `bacula_use_official_repo: true` when you need:
- Bacula version 10 or newer
- Latest features and bug fixes
- Versions newer than your distribution provides
- Consistent Bacula version across different OS distributions

**Supported Distributions** (latest 2 versions only):
- Debian: bookworm (12), trixie (13)
- Ubuntu: jammy (22.04), noble (24.04)

### Getting Started with Official Repository

**Step 1: Register for access key**
1. Visit https://www.bacula.org/bacula-binary-package-download/
2. Register for free (name + email)
3. Receive alphanumeric access key

**Step 2: Configure variables**

```yaml
# Enable official repository
bacula_use_official_repo: true

# REQUIRED: Your access key from bacula.org
bacula_repo_access_key: "your-access-key-here"

# REQUIRED: Bacula version to install
bacula_version: "13.0.4"
```

**Step 3: Run the role**

The role will automatically:
1. Validate required variables (fails if missing)
2. Check distribution compatibility
3. Download and install Bacula GPG signing key
4. Configure official repository
5. Install/upgrade Bacula packages

### Upgrading Existing Installations

**Yes, this works for upgrades!** The role handles:
- New installations (fresh Bacula setup)
- Upgrades from distribution packages to official repo
- Upgrades between official repo versions

When upgrading:
```yaml
# In your inventory or playbook
bacula_use_official_repo: true
bacula_repo_access_key: "your-key"
bacula_version: "13.0.4"  # Set desired version
```

The role will:
- Add official repository (if not present)
- Upgrade existing Bacula packages to specified version
- Preserve configuration files
- Restart services only if needed

**Important Notes:**
- Downgrades are not supported
- Database schema migrations happen automatically (make backups!)
- Configuration compatibility is maintained by Bacula

### Validation and Safety

The role includes built-in safety checks:

**Required variable validation:**
```
ERROR: Official Bacula repository requires:
- bacula_repo_access_key: Get your free access key from https://www.bacula.org/...
- bacula_version: Specify Bacula version (e.g., "13.0.4")
```

**Distribution compatibility check:**
```
ERROR: Distribution 'stretch' is not supported for official Bacula repository.
Supported distributions: bookworm, trixie, jammy, noble
```

If validation fails, the role **stops immediately** before making any changes.

### Example Configurations

**New installation with official repo:**
```yaml
---
- hosts: backup_servers
  become: true
  vars:
    bacula_use_official_repo: true
    bacula_repo_access_key: "abc123xyz789"
    bacula_version: "13.0.4"
    bacula_dir_role: true
    bacula_sd_role: true
    bacula_fd_role: true
  roles:
    - selfhostx.ansible.bacula
```

**Upgrade existing installation:**
```yaml
---
- hosts: bacula_director
  become: true
  vars:
    # Switch from distro packages to official repo
    bacula_use_official_repo: true
    bacula_repo_access_key: "{{ vault_bacula_repo_key }}"
    bacula_version: "13.0.4"
  roles:
    - selfhostx.ansible.bacula
```

**Continue using distribution packages:**
```yaml
---
- hosts: backup_servers
  become: true
  vars:
    # Default: use distribution packages
    bacula_use_official_repo: false
  roles:
    - selfhostx.ansible.bacula
```

### Technical Details

**GPG Key Management:**
- Debian/Ubuntu: Modern keyring method (`/usr/share/keyrings/`)
- RHEL/CentOS: `rpm --import` method
- Key URL: https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc
- Fingerprint: `5235 F5B6 68D8 1DB6 1704 A82D C0BE 2A5F E9DF 3643`

**Repository Configuration:**
- Debian/Ubuntu: `/etc/apt/sources.list.d/bacula-community.list`
- RHEL/CentOS: `/etc/yum.repos.d/bacula-community.repo`
- Old repository files are automatically removed

**Ansible Tags:**
```bash
# Setup repository only
ansible-playbook playbook.yml --tags bacula-repository

# Skip repository setup
ansible-playbook playbook.yml --skip-tags bacula-repository
```

**Package Naming Differences:**

Official Bacula repository uses different package names than Debian/Ubuntu:

| Component | Debian Package | Official Bacula Package |
|-----------|---------------|------------------------|
| Director (PostgreSQL) | bacula-director<br>bacula-director-pgsql<br>bacula-bscan | bacula-postgresql<br>bacula-common |
| Director (MySQL) | bacula-director<br>bacula-director-mysql<br>bacula-bscan | bacula-mysql<br>bacula-common |
| Storage Daemon | bacula-sd | bacula-sd<br>bacula-common |
| File Daemon (Client) | bacula-fd | bacula-client<br>bacula-common |
| Console | bacula-console | bacula-console<br>bacula-common |

The role automatically selects the correct package names based on `bacula_use_official_repo`.

When upgrading from distribution packages to official repository:
- Old Debian packages are automatically removed
- Official Bacula packages are installed with correct names
- Configuration files are preserved during the transition

## Quick start

### customize (at least) this vars:
(see example playbooks).

bacula_dir_fqdn: "bacula-dir.DOMAIN.TLD"
bacula_sd_fqdn: "bacula-sd.DOMAIN.TLD"

bacula_dir_restore_path: "/var/bacula-restores" (Default restore path)
bacula_sd_archive_device: "/var/bacula-volumes" (Default volume path)

-> DB engine (can be 'pgsql' or 'mysql')
bacula_dir_db_engine: mysql

### Define the director/SD via (host_vars / group_vars):

host_vars/bacula-dir.DOMAIN.TLD.yml

```yaml
---
bacula_console_role: True
bacula_dir_role: True
bacula_sd_role: True
bacula_fd_role: True
```

## Variables

### defaults

defaults are set here:
- defaults/main.yml
- vars/{{ ansible_os_family }}.yml

### vaulted passwords
my recommendation: set the following variables in your vault:

```yaml
bacula_console_password: ""
bacula_dir_dbpassword: ""
bacula_mon_password: ""
bacula_sd_password: ""
```

Attention: empty passwords are substituted with random values - on very run. Useful for testing - but not in production.
Exception are the FD-passwords, they will be preserved when bacula_fd_auto_psk is True (default).

### customize storage device (tape, Filestorage etc.)
Example: Ringbuffer 
- oldest data is recycled/overwritten when the storage is full
- size is bacula_sd_pool_max_volumes x bacula_sd_pool_max_volume_byte
Example: 10G x 100 Volumes means maximum capacity is ~1TB backupspace, depending on the amount

see template from var "bacula_sd_device_template" (default is [storage_device_include_ringbuffer.j2](templates/storage_device_include_ringbuffer.j2)) and optional more options from var "bacula_sd_device_extra_options".

### Storage Definitions
bacula_sd_device_name: "RingBuffer"
bacula_sd_media_type: "File"

**where to store the volumes**:

bacula_sd_archive_device: "/srv/bacula"
bacula_dir_pool_name: "Files"
bacula_dir_pool_label_format: "Bacula-Vol-"
bacula_dir_pool_recycle: "yes"

bacula_dir_pool_file_retention: "60 days" # Default: 60 days

bacula_dir_pool_job_retention: "24 months" # Default: 6 months

**Prune expired Jobs/Files**:

bacula_dir_pool_autoprune: "yes"
bacula_dir_pool_volume_rention: "3650 days"
bacula_dir_pool_max_volume_bytes: "10G"
bacula_dir_pool_max_volumes: 100

### Host overrides

Example: host_vars/host1.DOMAIN.TLD.yml

**own fileset**:
```yaml
bacula_fd_fileset_name: "fileset-of-host1"
bacula_fd_fileset_includes: |+
File = "/files/only/on/host1"
File = "/etc"
File = "/root"
bacula_fd_fileset_excludes: |+
File = "/files/EXCLUDED/on/host1"
File = "/proc"
```

**define jobs that the client should run before** (recommended to put this into group_vars or hosts_vars !):

```yaml
bacula_fd_client_run_before_job: command
bacula_fd_client_run_after_job: command
```

Example:
```yaml
bacula_fd_client_run_before_job: "/path/to/my/backupskript create"
bacula_fd_client_run_after_job: "/path/to/my/backupskript cleanup"
```

additonal note: for jobs running on director/server-side the vars "bacula_fd_run_before_job", "bacula_fd_run_after_job" or "bacula_fd_run_after_failed_job" are existing.

**additional options in job-ressource**:
```yaml
bacula_fd_extra_job_options: |+
Option1 = Example1
Option2 = Example2
```

Example: add more (than the predefined "bacula_fd_client_run_before_job") "Client Run Before Job" via bacula_fd_extra_job_options:
```yaml
bacula_fd_extra_job_options: |+
    Client Run Before Job = "additional before job" 
    Client Run After Job = "additional after job"
```

same goes **for client and jobdef**-ressources:

bacula_fd_extra_client_options
bacula_fd_extra_jobdefs_options

**different FQDN for connection to fd**:
```yaml
bacula_fd_connect_address: "different.fqdn.to.connect.to"
```
set source IP (default: the kernel will choose the best address according to the routing table):
```
bacula_fd_source_address: "IP_or_FQDN"
```

specific schedule for a host:
- set a (valid!) name for var bacula_fd_schedule (i.e. in host_vars/$hostname.yml with content "bacula_fd_schedule: MoreFrequentSchedule").


### Extend global schedules:

- see "bacula-dir-fileset-default.conf.j2" for a example.
- create your own config snippet (jinja2 template) with additional Schedules (i.e.: $ansibleroot/templates/bacula_dir_schedules_extra.j2)
- define the variable "bacula_dir_schedule_extra_template" with the filename of your template ("bacula_dir_schedule_extra.j2"), so it is included by the standard template bacula-dir-schedules.j2 :
  example: add in "group_vars/bacula_dir.yml" this line: bacula_dir_schedule_extra_template: "bacula_dir_schedules_extra.j2

### Extend global filesets:

same as schedules but the var is "bacula_dir_fileset_extra"

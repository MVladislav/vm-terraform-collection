# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [setup terraform](#setup-terraform)
  - [setup proxmox api access](#setup-proxmox-api-access)
    - [setup group](#setup-group)
    - [setup role](#setup-role)
    - [setup permission](#setup-permission)
    - [setup user](#setup-user)
    - [setup token](#setup-token)
  - [setup proxmox vm template](#setup-proxmox-vm-template)
    - [instructions - ubuntu 22.04 [jammy] template](#instructions---ubuntu-2204-jammy-template)
  - [References](#references)

---

## setup terraform

create file named `credentials.auto.tfvars`, with following values:

```tf
vm_count = 1

# ------------------------------------------------------------------------------

proxmox_api_url          = "https://<URL>:8006/api2/json"
proxmox_api_token_id     = "<ID>"
proxmox_api_token_secret = "<SECRET>"

# ------------------------------------------------------------------------------

proxmox_vm_ci_user = "<USERNAME>"
proxmox_vm_ci_pw   = "<PASSWORD>"
proxmox_vm_ssh_key = "<SSH_PUBLIC_KEY>"

proxmox_vm_name           = "ubuntu-impish"
proxmox_vm_desc           = "Ubuntu Server 21.10 (Impish)"
proxmox_vm_id             = "666"
proxmox_vm_target_node    = "proxmox"
proxmox_vm_template_clone = "template-ubuntu-impish-cloud-init"

proxmox_vm_bridge  = "vmbr0"
# do not add a last number at the end, this will be auto-gen at least for 9 vm's
proxmox_vm_macaddr = "86:AF:FE:AF:FE:0"

# ------------------------------------------------------------------------------

proxmox_vm_cpu       = "host" # "kvm64"
proxmox_vm_cores     = 2
proxmox_vm_memory_gb = 4
proxmox_vm_size_gb   = 32
```

---

## setup proxmox api access

### setup group

open `Datacenter > Permissions > Groups` \
create group, named like **terraform** \
or by **command**:

```sh
$pveum group add terraform
```

### setup role

open `Datacenter > Permissions > Roles` \
create new **role**, with following values:

- ...

or by **command**:

```sh
$pveum role add terraform -privs \
"VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit Sys.Audit"
```

for update role:

```sh
$pveum role modify terraform -privs \
"VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit Sys.Audit"
```

### setup permission

open `Datacenter > Permissions` \
create two new **group permisson**, with following values:

- Path: `/`
  Group: `terraform`  
  Role: `PVEVMAdmin`  
  Propagate: `x`
- Path: `/storage/local-zfs`
  Group: `terraform`  
  Role: `PVEDatastoreUser`  
  Propagate: `x`

or by **command**:

```sh
$pveum aclmod / -group terraform -role terraform
```

### setup user

open `Datacenter > Permissions > Users` \
create new **user**, with following values:

- User name: `terraform`
  Realm: `Proxmox VE authentication server` _(pve)_  
  Password: `***`  
  Group: `terraform`

or by **command**:

```sh
$pveum user add terraform@pve --password <password> --groups terraform
```

### setup token

open `Datacenter > Permissions > API Tokens` \
create new **token**, with following values:

_(when you create the token - save it - you can not show it later again)_

- User: `terraform@pve`
  Token ID: `terraform`  
  Privilege Seperation: ` ` _(empty)_

or by **command**:

```sh
$...
```

## setup proxmox vm template

To create vm over terraform in proxmox, \
we need first a template read setuped in proxmox to reference on it in terraform. \  
Templates need to be setup over console. \
You need to download an ready `.img` cloudimage for example for [ubuntu](https://cloud-images.ubuntu.com).

### instructions - ubuntu 22.04 [jammy] template

```sh
# download the image
$wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img \
-O /var/lib/vz/template/iso/jammy-server-cloudimg.img

# create a new VM
$qm create 9999 --name "template-ubuntu-jammy-cloud-init" --memory 2048 --net0 virtio,bridge=vmbr0 \
--cpu cputype=host,flags="+aes;+pdpe1gb" --sockets 1 --cores 2 --numa 1

# import the downloaded disk to local-zfs storage
$qm importdisk 9999 /var/lib/vz/template/iso/jammy-server-cloudimg.img local-zfs
# finally attach the new disk to the VM as scsi drive
$qm set 9999 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9999-disk-0,ssd=1,discard=on

# add cloud-init cd-rom drive
$qm set 9999 --ide2 local-zfs:cloudinit
$qm set 9999 --boot c --bootdisk scsi0
$qm set 9999 --serial0 socket --vga serial0
$qm set 9999 --agent 1
$qm set 9999 --hotplug disk,network,usb

# convert to template
$qm template 9999
```

---

## References

- <https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu>
- <https://pve.proxmox.com/wiki/Cloud-Init_Support>
- <https://pve.proxmox.com/pve-docs/qm.1.html>
- <https://cloud-images.ubuntu.com/jammy/current/>

---

**☕ COFFEE is a HUG in a MUG ☕**

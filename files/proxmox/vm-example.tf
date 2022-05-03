resource "proxmox_vm_qemu" "ubuntu_vm_clone" {
  count       = 2
  name        = "${var.proxmox_vm_name}-0${count.index + 1}"
  desc        = "${var.proxmox_vm_desc} 0${count.index + 1}"
  vmid        = var.proxmox_vm_id + count.index
  target_node = var.proxmox_vm_target_node

  clone      = var.proxmox_vm_template_clone
  full_clone = true

  agent = 0
  # boot     = "cdn"
  bootdisk = "scsi0"
  onboot   = false
  oncreate = true

  hotplug = "network,disk,usb,cpu,memory"

  cpu = "host"
  # cpu     = "kvm64"
  cores   = 1
  sockets = 1
  numa    = true

  memory  = 2048
  balloon = 0

  scsihw = "virtio-scsi-pci"
  disk {
    storage  = "local-zfs"
    type     = "scsi"
    size     = "8G"
    ssd      = 1
    backup   = 1
    discard  = "on"
    iothread = 1
  }

  network {
    bridge    = var.proxmox_vm_bridge
    model     = "virtio"
    firewall  = false
    link_down = false
    macaddr   = "${var.proxmox_vm_macaddr}${count.index + 1}"
  }

  os_type    = "cloud-init"
  ipconfig0  = "ip=dhcp"
  ciuser     = var.proxmox_vm_ci_user
  cipassword = var.proxmox_vm_ci_pw
  sshkeys    = <<EOF
  ${var.proxmox_vm_ssh_key}
  EOF

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

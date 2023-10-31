variable "cloudinit_template_name" {
    type = string 
}

variable "proxmox_node" {
    type = string
}

variable "ssh_key" {
  type = string 
  sensitive = true
}

resource "proxmox_vm_qemu" "terr-vm" {
  name = "terr-vm"
  target_node = var.proxmox_node
  clone = var.cloudinit_template_name
  agent = 1
  os_type = "cloud-init"
  cores = 1
  sockets = 1
  cpu = "host"
  memory = 2024
  scsihw = "virtio-scsi-pci"
  bios = "seabios"
  bootdisk = "scsi0"
  ciuser = "root"
  cipassword = "123456"
  ipconfig0 = "ip=10.10.10.236/24,gw=10.10.10.1"
  nameserver = "10.10.10.210"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
  }

  vga {
    type = "std"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
}
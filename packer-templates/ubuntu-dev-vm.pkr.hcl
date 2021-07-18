packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = number
  default = 40000
}

variable "headless" {
  type    = bool
  default = false
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "vm_name" {
  type   = string
  default = "ubuntu-dev-vm"
}

source "virtualbox-iso" "ubuntu-dev-vm" {
  # See https://www.packer.io/docs/builders/virtualbox/iso.
  guest_os_type = "Ubuntu_64"
  iso_url = "https://releases.ubuntu.com/20.04.2.0/ubuntu-20.04.2.0-desktop-amd64.iso"
  iso_checksum = "sha256:93bdab204067321ff131f560879db46bee3b994bf24836bb78538640f689e58f"
  communicator = "ssh"
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout = "20m"
  http_directory = "."
  headless = var.headless
  boot_wait = "5s"
  boot_command = [
    "<enter><enter><f6><esc><wait>",
    "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/unattended-files",
    "<enter><wait>"
  ]
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  disk_size = var.disk_size
  vm_name = var.vm_name
  vboxmanage = [
   ["modifyvm", "{{.Name}}", "--memory", var.memory],
   ["modifyvm", "{{.Name}}", "--cpus", var.cpus],
  ]
}

build {
  sources = ["sources.virtualbox-iso.ubuntu-dev-vm"]
}

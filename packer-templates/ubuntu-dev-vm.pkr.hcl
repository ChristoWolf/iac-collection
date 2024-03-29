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
  default = true
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "vm_name" {
  type   = string
  default = "ubuntu-dev-vm"
}

local "password" {
  expression = "vagrant"
  sensitive  = true
}

local "scripts_folder" {
  expression = "./scripts"
}

source "virtualbox-iso" "ubuntu-dev-vm" {
  # See https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso.
  guest_os_type = "Ubuntu_64"
  # Autoinstall requires Ubuntu Server, but that can be extended with ubuntu-desktop, see https://askubuntu.com/a/1253901.
  iso_url = "https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso"
  iso_checksum = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  communicator = "ssh"
  ssh_username = "vagrant"
  ssh_password = local.password
  ssh_timeout = "30m"
  ssh_handshake_attempts = 100000 # High number is needed, or Packer will fail during installation.
  http_directory = "./unattended-files/ubuntu-dev-vm"
  headless = var.headless
  boot_wait = "5s"
  boot_keygroup_interval = "500ms" # Needed to prevent missing key presses due to latency.
  # The reasoning behind the key presses is listed at the bottom of https://imagineer.in/blog/packer-build-for-ubuntu-20-04/.
  boot_command = [
    "<enter><enter><f6><esc><wait5>",
    " autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter>"
  ]
  shutdown_command = "echo ${local.password} | sudo -S shutdown -P now" # Password needs to be correct!
  disk_size = var.disk_size
  vm_name = var.vm_name
  vboxmanage = [
   ["modifyvm", "{{.Name}}", "--memory", var.memory],
   ["modifyvm", "{{.Name}}", "--cpus", var.cpus],
  ]
}

build {
  sources = ["sources.virtualbox-iso.ubuntu-dev-vm"]

  provisioner "shell" {
    scripts      = [
      "${local.scripts_folder}/init-apt.sh",
      "${local.scripts_folder}/install-guestadditions.sh",
      "${local.scripts_folder}/install-curl.sh",
      "${local.scripts_folder}/install-docker.sh", # Requires curl.
      "${local.scripts_folder}/install-powershell.sh",
      "${local.scripts_folder}/install-go.sh",
      "${local.scripts_folder}/install-git.sh"
    ]
    execute_command = "echo ${local.password} | {{.Vars}} sudo -S -E bash '{{.Path}}'"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
  }
}

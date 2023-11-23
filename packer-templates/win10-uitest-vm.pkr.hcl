packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "autounattend" {
  type    = string
  default = "./unattended-files/win10-uitest-vm/Autounattend.xml"
}

variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type = number
  # Computed using https://www.unitconverters.net/data-storage/gb-to-mb.htm.
  default = 102400
}

variable "iso_checksum" {
  type    = string
  default = "EF7312733A9F5D7D51CFA04AC497671995674CA5E1058D5164D6028F0938D668"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type = string
  # See also https://github.com/StefanScherer/packer-windows/blob/main/windows_10.json.
  default = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "usb" {
  type    = bool
  default = true
}

# Keep https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/naming-conventions-for-computer-domain-site-ou
# in mind (i.e. max. 15 characters)!
variable "vm_name" {
  type    = string
  default = "win10-uitest-vm"
}

# Local variables.

local "password" {
  expression = "vagrant"
  sensitive  = true
}

local "scripts_folder" {
  expression = "./scripts"
}

# See https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso.
source "virtualbox-iso" "win10-uitest-vm" {
  boot_wait    = "2m"
  communicator = "ssh"
  disk_size    = var.disk_size
  cpus         = var.cpus
  memory       = var.memory
  floppy_files = [
    "${var.autounattend}",
    "${local.scripts_folder}/Install-OpenSSH.ps1"
  ]
  guest_os_type    = "Windows10_64" # Can be found via `VBoxManage list ostypes`.
  headless         = "false"
  iso_checksum     = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url          = var.iso_url
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  usb              = var.usb
  vm_name          = var.vm_name
  ssh_password     = local.password
  ssh_timeout      = "6h"
  ssh_username     = "vagrant"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", var.memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.cpus],
  ]
}

build {
  sources = ["sources.virtualbox-iso.win10-uitest-vm"]

  provisioner "powershell" {
    elevated_password = "vagrant"
    elevated_user     = local.password
    scripts = [
      "${local.scripts_folder}/Disable-WindowsUpdates.ps1",
      "${local.scripts_folder}/Disable-PwExpiration.ps1",
      "${local.scripts_folder}/Disable-Hibernate.ps1",
      "${local.scripts_folder}/Disable-Screensaver.ps1",
      "${local.scripts_folder}/Disable-Notifications.ps1",
      "${local.scripts_folder}/Uninstall-WindowsPhotos.ps1",
      "${local.scripts_folder}/Disable-NewsFeed.ps1",
      "${local.scripts_folder}/Enable-DeveloperMode.ps1",
      "${local.scripts_folder}/Install-WinAppDriver.ps1",
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    compression_level   = 9
  }
}

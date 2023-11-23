packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

# Since Windows 11, the Autounattend.xml file
# NEEDS to set very specific registry values
# to bypass TPM, secure boot and hardware requirements.
# Needs to be done using `RunSynchronous` commands
# in the `Microsoft-Windows-Setup` component.
# I failed to do it using boot commands
# (as it is done in https://github.com/StefanScherer/packer-windows/blob/main/windows_11.json)
variable "autounattend" {
  type    = string
  default = "./unattended-files/win11-uitest-vm/Autounattend.xml"
}

variable "cpus" {
  type    = string
  default = "2"
}

# Needs at least 64 GB,
# see https://www.microsoft.com/en-us/windows/windows-11-specifications.
variable "disk_size" {
  type = number
  # Computed using https://www.unitconverters.net/data-storage/gb-to-mb.htm.
  default = 102400
}

variable "iso_checksum" {
  type    = string
  default = "EBBC79106715F44F5020F77BD90721B17C5A877CBC15A3535B99155493A1BB3F"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type = string
  # See also https://github.com/StefanScherer/packer-windows/blob/main/windows_11.json.
  default = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
}

# Needs at least 4 GB of RAM,
# see https://www.microsoft.com/en-us/windows/windows-11-specifications.
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
  default = "win11-uitest-vm"
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
source "virtualbox-iso" "win11-uitest-vm" {
  boot_wait    = "2m"
  communicator = "ssh"
  disk_size    = var.disk_size
  cpus         = var.cpus
  memory       = var.memory
  floppy_files = [
    "${var.autounattend}",
    "${local.scripts_folder}/Install-OpenSSH.ps1"
  ]
  guest_os_type    = "Windows11_64" # Can be found via `VBoxManage list ostypes`.
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
  sources = ["sources.virtualbox-iso.win11-uitest-vm"]

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

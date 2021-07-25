# iac-collection
Collection of IaC-based infrastructure definitions, templates, configurations and scripts

## Prerequisites



## Usage

- `packer build ./packer-templates/<Packer template to build>`

- `vagrant validate`
- C:\dev\iac-collection\vagrant-files\ubuntu-dev-vm>vagrant box add ubuntu-dev-vm ./../../packer_ubuntu-dev-vm_virtualbox.box
- `vagrant box list`
- `set "VM_NAME=testvm" && vagrant up`
- `vagrant destroy` (-f -g)?
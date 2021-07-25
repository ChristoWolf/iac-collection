# iac-collection
Collection of IaC-based infrastructure definitions, templates, configurations and scripts

## Disclaimer

I have only tried this on a Windows 10 (`winver` 20H2) physical host.
If you find any issues, feel free to contribute by creating an issue or a pull request!

## Dependencies

1. Install [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli), version >= 1.7.
2. Install [Vagrant](https://www.vagrantup.com/docs/installation), version >= 2.2.
3. Install [VirtualBox + Extension Pack](https://www.virtualbox.org/wiki/Downloads), version >= 6.1.

## Usage quick guides

### Create VM using Packer

1. Inside the repository's root folder, execute :
   ```
   packer build ./packer-templates/<Packer template to build>
   ```
   This might take some time.
2. Either import the VM from the Packer-output folder `output-<built Packer template name>` or make use of the generated Vagrant box, see below.

### Control lifecycle of a Vagrant box

All of the following should be executed inside `./vagrant-files/<desired Vagrantfile folder>` located under the repository's root.
These are just the most important examples, see [Vagrant's command doc](https://www.vagrantup.com/docs/cli) for more.

- Add a Vagrant box from a generated box file:
   ```
   vagrant box add <Vagrantfile box name, e.g. ubuntu-dev-vm> <Vagrant box file path>
   ```
- Check if the box is available:
   ```
   vagrant box list
   ```
- Start the VM (automatically provisioned if it is the first start):
   ```
   set "VM_NAME=<desired VM/host name>" && vagrant up
   ```
- SSH into the running VM:
   ```
   vagrants ssh
   ```
- Forcefully and gracefully shut down the VM:
   ```
   vagrant destroy -f -g
   ```
# iac-collection
Collection of IaC-based infrastructure definitions, templates, configurations and scripts

## Disclaimer

I have only tried this on a Windows 10 (`winver` 20H2) physical host.
If you find any issues, feel free to contribute by creating an issue or a pull request!

## Dependencies

1. Install [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli), version >= 1.7.
2. Install [Vagrant](https://www.vagrantup.com/docs/installation), version >= 2.2.
3. Install [VirtualBox + Extension Pack](https://www.virtualbox.org/wiki/Downloads), version >= 6.1.
4. If using a Windows host, make sure to disable all built-in virtualization features, as they WILL mess with third-party virtualization! Namely, disable these Windows features:
   - Hyper-V (and child features)
   - Virtual Machine Platform
   - Windows Hypervisor Platform
   - Windows Subsystem for Linux (i.e. WSL 1/2)

   I know that this locks us out of those features, but there are [many advantages to this](#wsl-2-vs-third-party-virtualization)!

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
The terminal should be elevated to ensure proper execution (as e.g. symlinks won't be possible otherwise).

Following are just the most important examples, see [Vagrant's command doc](https://www.vagrantup.com/docs/cli) for more.

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
- Shut down the VM:
   ```
   vagrant halt
   ```
- Forcefully destroy (clean up) the VM:
   ```
   vagrant destroy -f
   ```

### Using the VM as a remote Docker host

The `ubuntu-dev-vm` already comes provisioned with the newest version of Docker.
You can either interact with its Docker CLI directly on the VM or use it as a remote Docker host.

For this, I suggest using VS Code and [configuring/extending it appropriately](https://code.visualstudio.com/docs/remote/containers-advanced#_developing-inside-a-container-on-a-remote-docker-host).
Other than that, your client still requires Docker CLI and docker-compose CLI to remotely interact with the Docker host.

### Hostname resolution

By default, the VM is only reachable from outside via its dynamically assigned IP address. You can get it by `vagrant ssh`ing into the machine. If not shown upon login, you may additionally execute `ip a`. It's the second (bridged) adapter's IP.

Automatic hostname registration is not implemented yet as it highly depends on the host machine.
For now, consider doing it manually by registering it in your host's [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)) or your DNS, if feasible.

If needed, you can also set a [static IP](`ubuntu-dev-vm`) for the bridged adapter, besides a wide range of other [networking options](https://www.vagrantup.com/docs/networking).

### WSL 2 vs. third-party virtualization

You might ask yourself, "why not just use WSL 2?". It mainly boils down to what you want to achieve with your virtual Linux system.

WSL 2 might be sufficient for many development use cases, but `ubuntu-dev-vm` offers much more playground versatility (e.g. as a test system):
- It's a fully featured Linux system. You could even install a full UI if needed. It even offers out-of-the-box hardware integration (e.g. of USB ports).
- Packer and Vagrant make configuration, provisioning and deployment trivial and fully automatable, following the IaC principle. These version-controllable environments can be easily shared and modified. If something does not suit your needs, just change it!
- It supports complete VM lifecycle management via Vagrant's CLI.
- If you want to use different hypervisors, you can do so by simply listing them in the Packer and Vagrant files/templates.
- Windows hosts still suffer from [compatibility issues between Hyper-V and third-party hypervisors](https://docs.microsoft.com/en-us/troubleshoot/windows-client/application-management/virtualization-apps-not-work-with-hyper-v), making it hard to use WSL 2 and proper virtualization in tandem.
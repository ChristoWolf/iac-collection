#!/bin/bash

# Vagrant needs passwordless sudo to be configured for the user, see
# https://www.vagrantup.com/docs/boxes/base#password-less-sudo.
# Examples:
# - https://nickhowell.uk/2020/05/01/Automating-Ubuntu2004-Images/
# - https://imagineer.in/blog/packer-build-for-ubuntu-20-04/

# Don't bother, this does not work...
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
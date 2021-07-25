#!/bin/bash

add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get install -y git
git --version

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt-get install -y git-lfs

ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
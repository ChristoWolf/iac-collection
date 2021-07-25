#!/bin/bash

# See https://github.com/golang/go/wiki/Ubuntu.
# Official way would be https://golang.org/doc/install.
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt update
sudo apt install -y golang-go
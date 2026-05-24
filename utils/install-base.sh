#!/data/data/com.termux/files/usr/bin/bash

set -e

pkg update -y
pkg install git nodejs-lts -y

echo "git y nodejs-lts instalados."

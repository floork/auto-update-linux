#!/bin/bash

normal_packages() {
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get -y update && sudo apt-get -y upgrade
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y update
    elif [ -x "$(command -v emaint)" ]; then
        sudo emaint -a sync
    elif [ -x "$(command -v pacman)" ]; then
        if [ -x "$(command -v pamac)" ]; then
            pamac -Syu
        elif [ -x "$(command -v paru)" ]; then
            paru -Syu
        elif [ -x "$(command -v yay)" ]; then
            yay -Syu
        else
            sudo pacman -Syu --noconfirm
        fi
    elif [ -x "$(command -v yum)" ]; then
        sudo yum -y update
    else
        echo 'This Distro is not supported!'
    fi
}
extra_packages() {
    if [ -x "$(command -v flatpak)" ]; then
        flatpak update -y
    fi
    if [ -x "$(command -v nix)" ]; then
        sudo nix-env -u -y
    fi
    if [ -x "$(command -v snap)" ]; then
        sudo snap refresh -y
    fi
}

normal_packages
extra_packages

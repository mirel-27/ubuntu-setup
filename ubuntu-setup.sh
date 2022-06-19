#!/bin/bash

APT_GET_UPDATE="sudo apt-get update"
APT_GET_UPGRADE="sudo apt-get upgrade"
APT_GET_INSTALL="sudo apt-get install "

PROMPT_STR="[Y/n]"

update_packages()
{
        echo "Recommendation is to update and upgrade packages before any further modifications."
        echo "Update and upgrade packages? $PROMPT_STR"
        read to_update_packages
  
        if [ $to_update_packages == "Y" ] || [ $to_update_packages == "y" ]
        then
                echo "Updating packages ..."
                
                yes | $APT_GET_UPDATE 
                yes | $APT_GET_UPGRADE

                echo "Done."
        else
                echo "Skipping packages update ..."
        fi
}

install_git()
{
        echo "Install git? $PROMPT_STR"
        read to_install_git


        if [ $to_install_git == "Y" ] || [ $to_install_git == "y" ]
        then
                echo "Installing git ..."

                yes | $APT_GET_INSTALL git

                echo "Done."
        else
                echo "Skipping git installation ..."
        fi
}

install_vscode()
{
        echo "Install vscode? $PROMPT_STR"
        read to_install_vscode

        if [ $to_install_vscode == "Y" ] || [ $to_install_vscode == "y" ]
        then
                echo "Installing vscode ..."
                
                # install the apt repository and signing key to enable auto-updating using the system's package manager
                # https://code.visualstudio.com/docs/setup/linux

                $APT_GET_INSTALL wget gpg
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                rm -f packages.microsoft.gpg

                # update and install

                $APT_GET_INSTALL apt-transport-https
                sudo apt update
                $APT_GET_INSTALL code

                echo "Done."
        else
                echo "Skipping vscode installation ..."
        fi
}

install_python_toolchain()
{
        # install pip
}

install_cpp_toolchain()
{
        echo "Install g++/gcc and supporting toolchain? $PROMPT_STR"
        read to_install_cpp_toolchain

        if [ $to_install_cpp_toolchain == "Y" ] || [ $to_install_cpp_toolchain == "y" ]
        then
                echo "Installing C++ toolchain ..."

                # install build-essentials:
                #  - g++
                #  - gcc
                #  - debugger
                #  - make
                yes | $APT_GET_INSTALL build-essential

                # install two older versions of g++/gcc
                yes | $APT_GET_INSTALL gcc-9 g++-9 gcc-10 g++-10

                # install valgrind
                yes | $APT_GET_INSTALL valgrind

                # install CMake
                yes | $APT_GET_INSTALL cmake

                # install CMake documentation package
                yes | $APT_GET_INSTALL cmake-doc

                # install cppcheck
                yes | $APT_GET_INSTALL cppcheck

                # install clang-format
                yes | $APT_GET_INSTALL clang-format

                # install conan

                # install astyle
                yes | $APT_GET_INSTALL astyle

                echo "Done."
        else
                echo "Skipping g++/gcc toolchain installation ..."
        fi
}

echo "Hello $USER!"
echo "You are about to setup your ubuntu dev environment."

update_packages
install_git
install_vscode
install_python_toolchain
install_cpp_toolchain

# install gnome-tweaks

# install curl

# install zsh

# install java

# setup ssh keys

# setup git

# setup bash aliases

# setup zsh

echo "Environment set!"

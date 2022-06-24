#!/bin/bash

APT_GET_UPDATE="sudo apt-get update"
APT_GET_UPGRADE="sudo apt-get upgrade"
APT_GET_INSTALL="sudo apt-get install "
PIP_INSTALL="pip install "

PROMPT_STR="[Y/n]"
SEPARATOR_STR="--------------------------------------------------------------------------------------------"

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

install_python_tools()
{
    echo "Install python and supporting tools? $PROMPT_STR"
    read to_install_python_tools

    if [ $to_install_python_tools == "Y" ] || [ $to_install_python_tools == "y" ]
    then
        echo "Installing python and tools ..."
        tools=("python3" "python3-pip")

        for i in ${!tools[@]}; do
                echo "[$i] Installing ${tools[$i]} ..."
                yes | $APT_GET_INSTALL ${tools[$i]}
        done
    else
        echo "Skipping python and supporting tools installation ..."
    fi
}

install_cpp_tools()
{
    echo "Install g++/gcc and supporting toolchain? $PROMPT_STR"
    read to_install_cpp_tools

    if [ $to_install_cpp_tools == "Y" ] || [ $to_install_cpp_tools == "y" ]
    then
        echo "Installing C++ and tools ..."

        apt_tools=("build-essential" "gcc-9" "gcc-10" "g++-9" "g++-10" "valgrind" "cmake" "cmake-doc" "cppcheck" "clang-format" "astyle")

        for i in ${!apt_tools[@]}; do
                echo "[$i] Installing ${apt_tools[$i]} ..."
                        yes | $APT_GET_INSTALL ${apt_tools[$i]}
                echo "[$i] Done."
        done

        pip_tools=("conan")
            for i in ${!pip_tools[@]}; do
            echo "[$i] Installing ${pip_tools[$i]} ..."
                    yes | $PIP_INSTALL ${pip_tools[$i]}
            echo "[$i] Done."
        done

        echo "Done."
    else
        echo "Skipping g++/gcc toolchain installation ..."
    fi
}

install_java()
{
    echo "Install java? $PROMPT_STR"
    read to_install_java

    if [ $to_install_java == "Y" ] || [ $to_install_java == "y" ]
    then
        java_tools=("openjdk-17-jdk" "openjdk-17-jre")

        for i in ${!java_tools[@]}; do
            echo "[$i] Installing ${java_tools[$i]} ..."
            yes | $APT_GET_INSTALL ${java_tools[$i]}
            echo "[$i] Done."
        done
    else
        echo "Skipping java installation ..."
    fi
}

install_misc()
{
    misc_tools=("gnome-tweaks" "curl" "zsh")

    for i in ${!misc_tools[@]}; do
        echo "Install ${misc_tools[$i]} $PROMPT_STR?"
        read to_install

        if [ $to_install == "Y" ] || [ $to_install == "y" ]
        then
            yes | $APT_GET_INSTALL ${misc_tools[$i]}
            echo "Done."
        else
            echo "Skipping ${misc_tools[$i]} installation ..."
        fi
    echo $SEPARATOR_STR
    done
}

echo $SEPARATOR_STR
echo "  _   _   _                       _                     ____           _                   "
echo " | | | | | |__    _   _   _ __   | |_   _   _          / ___|    ___  | |_   _   _   _ __  "
echo " | | | | | '_ \  | | | | | '_ \  | __| | | | |  _____  \___ \   / _ \ | __| | | | | | '_ \ "
echo " | |_| | | |_) | | |_| | | | | | | |_  | |_| | |_____|  ___) | |  __/ | |_  | |_| | | |_) |"
echo "  \___/  |_.__/   \__,_| |_| |_|  \__|  \__,_|         |____/   \___|  \__|  \__,_| | .__/ "
echo "                                                                                    |_|    "
echo $SEPARATOR_STR
echo "Hello $USER!"
echo "You are about to setup your ubuntu dev environment."
echo $SEPARATOR_STR

update_packages
echo $SEPARATOR_STR

install_python_tools
echo $SEPARATOR_STR

install_git
echo $SEPARATOR_STR

install_vscode
echo $SEPARATOR_STR

install_cpp_tools
echo $SEPARATOR_STR

install_java
echo $SEPARATOR_STR

install_misc

echo "Environment set!"
echo $SEPARATOR_STR

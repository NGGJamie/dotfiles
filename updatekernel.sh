#!/bin/bash

# Checks if the kernel being run is the newest version. If not,
# Download the new kernel from kernel.org and offer to compile it.
# Developed primarily for Linux Mint
# Author: Jamie (https://github.com/NGGJamie)

# This script should NOT be run as root

KLNK=$(curl -sq "https://www.kernel.org/" | grep "https://cdn.kernel.org/pub/linux/kernel/" | head -n 1 | grep -Eo "https.*tar.xz")
FRNDLY=$(echo $KLNK | grep -Eo "linux-.*")
NVER=$(echo $KLNK | sed 's/^.*linux-//;s/.tar.xz//');
CVER=$(uname -r | sed 's/-.*//');
BUILD_DIR="changeme"
AUTOY="n"

export CHOST="x86_64-pc-Linux-gnu"
export CFLAGS="-march=native -O2 -pipe"
export CXXFLAGS="$CFLAGS"
export CONCURRENCY_LEVEL=$(nproc)

if [ "$UID" = "0" ]
then
	echo "This script will not run as root for safety reasons.";
	exit;
fi

if [ "$BUILD_DIR" = "changeme" ]
then
	read -p "Please enter a directory to download & compile the kernel in: " BUILD_DIR;
	sed --in-place=.bak "s~BUILD_DIR=\"changeme\"~BUILD_DIR=\"$BUILD_DIR\"~" "$0";
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
	printf "newkern.sh - Update and optionally build the latest kernel from kernel.org\n\n";
	printf "\t-h/--help - Display this help dialogue\n\t--rm-build - Delete the kernel build directory\n";
	exit;
fi
if [ "$1" = "--rm-build" ]
then
	read -n 1 -p "Are you sure you want to remove the build directory? [Y/N]" yn;
	printf "\n";
	if [ $yn = "y" ] || [ $yn = "Y" ]
	then
		rm -rfv "$BUILD_DIR";
	fi
	exit;
fi

if [ "$1" = "-y" ]
then
	AUTOY="y";
	yn="y"
fi

if [ "$(echo "$1" | cut -d"=" -f 1)" = "--kname" ]
then
	KNAME=$(echo "$1" | cut -d"=" -f 2);
fi

if [ $NVER != $CVER ]
then
	echo "There is a new kernel available.";
	if [ $AUTOY != "y" ]
	then
		read -n 1 -p "Would you like to download it? [Y/N] " yn;
	fi
	if [ $yn = "y" ] || [ $yn = "Y" ]
	then
		printf "\nRetrieving the latest kernel and saving it to $BUILD_DIR\n";
		mkdir -p $BUILD_DIR;
		stat $BUILD_DIR/$FRNDLY 2>&1 >/dev/null
		if [ $? = 1 ]
		then
			wget -O $BUILD_DIR/$FRNDLY "$KLNK";
			echo "Download complete.";
		else
			echo "$BUILD_DIR/$FRNDLY already exists. Skipping download";
		fi
		if [ "$AUTOY" != "y" ]
		then
			read -n 1 -p "Would you like to build the new kernel now? [Y/N] " yn;
		fi
		if [ $yn = "y" ] || [ $yn = "Y" ]
		then
			dpkg -l build-essential kernel-package libncurses5-dev fakeroot wget bzip2 libssl-dev
			if [ "$?" = "1" ]
			then
				echo "You are missing packages required for kernel building."
				sleep 2;
				read -n 1 -p "Would you like to install them now? (NOTE: REQUIRES A DEBIAN-LIKE SYSTEM. WILL PROMPT FOR SUDO) [Y/N] " yn;
				if [ $yn  = "y" ] || [ $yn = "Y" ]
				then
					sudo apt-get install build-essential kernel-package libncurses5-dev fakeroot wget bzip2 libssl-dev;
					if [ "$?" = "1" ]
					then
						echo "Package install failed, quitting!";
						exit
					fi
				fi
			fi
			printf "\nTraversing to $BUILD_DIR\n";
			cd $BUILD_DIR;
			tar xf "$FRNDLY"
			echo "Entering $(echo $FRNDLY | sed 's/.tar.xz//')";
			cd $(echo $FRNDLY | sed 's/.tar.xz//');
			make mrproper;
			cp -v /boot/config-`uname -r` ./.config;
			make oldconfig;
			fakeroot make-kpkg --initrd "--append-to-version=-$KNAME" kernel_image kernel_headers
			echo "Compilation complete. Please double check to ensure success."
			sleep 3;
			if [ "$AUTOY" != "y" ]
			then
				read -n 1 -p "Would you like to remove the build directory that was created? (Your generated deb files will be safe) [Y/N] " yn
			fi
			echo;
			if [ $yn = "y" ] || [ $yn = "Y" ]
			then
				cd ..;
				mv *.deb ..;
				cd ..;
				rm -rf "$BUILD_DIR"
			fi
		fi
	fi
else
	echo "Your kernel is up-to-date.";
fi

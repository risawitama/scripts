#!/bin/bash

rm -rf .repo/local_manifests

echo "----------------DELETED DIRECTORIES----------------"


repo init -u https://github.com/PixelOS-AOSP/manifest.git -b fourteen --git-lfs --depth=1

echo "--------------REPO INITIALISED---------------"


# Clone local_manifests repository
git clone https://github.com/risawitama/local_manifests --depth=1 -b pos .repo/local_manifests
if [ ! 0 == 0 ]
    then curl -o .repo/local_manifests https://github.com/risawitama/local_manifests.git
fi

echo "-----------------CLONED local manifest-------------------"


# Resync
/opt/crave/resync.sh

echo "---------------RESYNCED-----------------"


# Lunch
export BUILD_USERNAME=risawitama
export BUILD_HOSTNAME=crave
source build/envsetup.sh
breakfast onclite eng
make installclean
mka bacon

echo "--------------BUILD STARTED--------------"

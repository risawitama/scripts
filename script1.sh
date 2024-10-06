#!/bin/bash

rm -rf .repo/local_manifests
rm -rf device/samsung
rm -rf kernel/samsung
rm -rf vendor/samsung
rm -rf hardware/samsung

# Cleanup to fix SyncErrors raised during branch checkouts
rm -rf platform/prebuilts

echo "========================================================================"
echo "DELETED DIRECTORIES"
echo "========================================================================"


# Repo Init
repo init -u https://github.com/ProjectPixelage/android_manifest.git -b 15 --git-lfs --depth=1

echo "========================================================================"
echo "REPO INITIALIZED"
echo "========================================================================"


# Clone local_manifests repository
git clone https://github.com/koko-07870/local_manifests --depth 1 -b pixelage .repo/local_manifests


echo "========================================================================"
echo "CLONED REPOS"
echo "========================================================================"


# Resync

/opt/crave/resync.sh

echo "========================================================================"
echo "RESYNCED"
echo "========================================================================"


# Upgrade System and install openssl

sudo apt update && sudo apt upgrade -y

echo "========================================================================"
echo "SYSTEM UPGRADED"
echo "========================================================================"


# Clone Custom Clang

CUSTOMCLANG="r522817"
rm -rf "prebuilts/clang/host/linux-x86/clang-${CUSTOMCLANG}"
git clone --depth=1 https://gitlab.com/kei-space/clang/r522817 prebuilts/clang/host/linux-x86/clang-${CUSTOMCLANG}

echo "========================================================================"
echo "CLONED CUSTOM CLANG"
echo "========================================================================"



echo "========================================================================"
echo "BUILDING........."
echo "========================================================================"


# Lunch
export PIXELAGE_BUILD="a52q"
source build/envsetup.sh
lunch pixelage_a52q-ap3a-userdebug
make installclean
mka bacon

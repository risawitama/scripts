#!/bin/bash

rm -rf .repo/local_manifests
rm -rf device/samsung
rm -rf vendor/samsung
rm -rf hardware/samsung
rm -rf kernel/samsung
rm -rf vendor/support

repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 15

git clone https://github.com/koko-07870/local_manifests --depth 1 -b main .repo/local_manifests

/opt/crave/resync.sh

rm -rf vendor/derp/signing/keys
git clone https://github.com/koko-07870/scripts -b tmp vendor/derp/signing/keys

# Export
export BUILD_USERNAME=koko-07870
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"


source build/envsetup.sh

lunch derp_a52q-user && make installclean && make update-api && mka derp


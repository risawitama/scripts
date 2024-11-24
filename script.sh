#!/bin/bash

rm -rf .repo/local_manifests

repo init -u https://github.com/PixelOS-AOSP/manifest.git -b fourteen --git-lfs --depth=1

git clone https://github.com/risawitama/local_manifests --depth=1 -b pos .repo/local_manifests

# sync
/opt/crave/resync.sh

# temp
#rm -rf packages/apps/FMRadio
#rm -rf vendor/qcom/opensource/libfmjni

# Export
export BUILD_USERNAME=risawitama
export BUILD_HOSTNAME=crave
export TARGET_BOOT_ANIMATION_RES=720
source build/envsetup.sh
breakfast onclite eng && make installclean && lunch aosp_onclite-ap2a-eng && mka bacon

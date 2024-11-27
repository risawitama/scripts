#!/bin/bash

# Remove
rm -rf .repo/local_manifests

# Init
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs --depth=1

# Local Manifests
git clone https://github.com/risawitama/local_manifests --depth=1 -b rising .repo/local_manifests

# Sync
/opt/crave/resync.sh

# Export
export BUILD_USERNAME=risawitama
export BUILD_HOSTNAME=crave
source build/envsetup.sh
breakfast onclite eng && make installclean && riseup onclite eng && rise b

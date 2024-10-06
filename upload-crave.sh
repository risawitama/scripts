#!/bin/bash

cd Pixel14

echo "========================================================================"
echo "Inside the Project dir"
echo "========================================================================"

rm .repo/manifests/crave.yaml* || true; # Removes existing crave.yamls

curl -o .repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml

echo "========================================================================"
echo "cloned crave yaml"
echo "========================================================================"

crave pull out/target/product/a52q/PixelOS_a52q-14.0-20241006-0548.zip

echo "========================================================================"
echo "pulled rom zip"
echo "========================================================================"

cd /home/crave-devspaces

echo "========================================================================"
echo "home dir"
echo "========================================================================"

./upload.sh Pixel14/out/target/product/a52q/PixelOS_a52q-14.0-20241006-0548.zip

echo "========================================================================"
echo "Upload done"
echo "========================================================================"

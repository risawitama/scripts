#!/bin/bash

DIRROM="Pixel14/"
# Check if the directory exists
if [ -d "$DIRROM" ]; then
    echo "Directory $DIRROM exists."
    cd "$DIRROM"
    rm .repo/manifests/crave.yaml* || true; # Removes existing crave.yamls
    curl -o .repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml
    echo "--------------cloned crave yaml---------------"
    crave pull out/target/product/a52q/*.zip
else
    echo "Directory $DIRROM does not exist.creating."
    crave clone create --projectID 82 /crave-devspaces/Pixel14
    cd "$DIRROM"
    rm .repo/manifests/crave.yaml* || true; # Removes existing crave.yamls
    curl -o .repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml
    echo "--------------cloned crave yaml---------------"
    crave pull out/target/product/a52q/*.zip
fi

#!/bin/bash

DIRROM="Pixel14"
# Check if the directory exists
if [ -d "$DIRROM" ]; then
    echo "Directory $DIRROM exists."
    rm "$DIRROM"/.repo/manifests/crave.yaml* || true; # Removes existing crave.yamls
    curl -o "$DIRROM"/.repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml
    echo "--------------cloned crave yaml---------------"
    crave pull "$DIRROM"/out/target/product/a52q/*.zip
else
    echo "Directory $DIRROM does not exist.creating."
    crave clone create --projectID 82 /crave-devspaces/Pixel14
    rm "$DIRROM"/.repo/manifests/crave.yaml* || true; # Removes existing crave.yamls
    curl -o "$DIRROM".repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml
    echo "--------------cloned crave yaml---------------"
    crave pull "$DIRROM"/out/target/product/a52q/*.zip
fi

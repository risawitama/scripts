#!/bin/bash

DIRROM="Pixel14/"
# Check if the directory exists
if [ -d "$DIRROM" ]; then
    echo "Directory $DIRROM exists."
else
    echo "Directory $DIRROM does not exist.creating."
    crave clone create --projectID 82 /crave-devspaces/Pixel14
fi


#crave yaml
rm pos/.repo/manifests/crave.yaml* || true; # Removes existing crave.yamls

curl -o Pixel14/.repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml

echo "--------------cloned crave yaml---------------"


crave pull Pixel14/out/target/product/a52q/*.zip

echo "---------------pulled rom zip----------------"

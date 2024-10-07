#!/bin/bash

DIRROM="Pixel14/"
# Check if the directory exists
if [ -d "$DIRROM" ]; then
    echo "Directory $DIRROM exists. Deleting it..."
    crave clone destroy "$DIRROM" -y
    echo "Directory deleted."
else
    echo "Directory $DIRROM does not exist. No need to delete."
fi

#Create Project Dir
crave clone create --projectID 82 /crave-devspaces/Pixel14

echo "---------Project dir Created------------"


#Go into the dir
cd Pixel14

echo "-----------Inside the Project dir-------------"


#crave yaml
rm .repo/manifests/crave.yaml* || true; # Removes existing crave.yamls

curl -o .repo/manifests/crave.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/crave/crave.yaml.aosp # Downloads crave.yaml

echo "--------------cloned crave yaml---------------"


crave pull out/target/product/a52q/PixelOS_a52q-14.0-20241007-0106.zip

echo "---------------pulled rom zip----------------"


cd /home/crave-devspaces

echo "-----------home dir----------------"


#gofile upload
./upload.sh Pixel14/out/target/product/a52q/PixelOS_a52q-14.0-20241007-0106.zip

echo "------------Upload done----------"

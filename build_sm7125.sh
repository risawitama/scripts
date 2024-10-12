#!/bin/bash
#
# Ascendia Build Script - sm7125
# Coded by BlackMesa123 @2023
# Modified and adapted by RisenID @2024
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

# Change this according to what you need
DATE=`date +%Y%m%d`
ANDROID_VERSION="14.0"
SPARK_VERSION="1.1"
SPARK_VERSION_1="1"
# Clang r487747c
TC_DIR=/home/koko/pos/kernel/clang

# ! DON'T CHANGE THESE !
SRC_DIR=$(pwd)/new-14
OUT_DIR=/home/koko/pos/kernel/out
MAIN_DIR=$(pwd)
JOBS=32

MAKE_PARAMS="-j$JOBS -C $SRC_DIR O=$SRC_DIR/out \
	ARCH=arm64 AR="llvm-ar" NM="llvm-nm" LD="ld.lld" AS="llvm-as" STRIP="llvm-strip" \
	OBJCOPY="llvm-objcopy" OBJDUMP="llvm-objdump" CLANG_TRIPLE=aarch64-linux-gnu- \
	CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-"

export PATH="$TC_DIR/bin:$PATH"
# ! DON'T CHANGE THESE !

CLEAN_SOURCE()
{
	echo "----------------------------------------------"
	echo "Cleaning up sources..."
	rm -rf $SRC_DIR/out
}

BUILD_KERNEL()
{
	echo "----------------------------------------------"
	[ -d "$SRC_DIR/out" ] && echo "Starting kernel build... (DIRTY)" || echo "Starting  kernel build..."
	echo " "
	export LOCALVERSION="-Spark-$ANDROID_VERSION-$SPARK_VERSION"
	mkdir -p $SRC_DIR/out
	make $MAKE_PARAMS CC="ccache clang" vendor/$DEFCONFIG
	echo " "
	make $MAKE_PARAMS CC="ccache clang"
	echo " "
}

REGEN_DEFCONFIG()
{
	echo "----------------------------------------------"
	[ -d "$SRC_DIR/out" ] && echo "Starting $VARIANT kernel build... (DIRTY)" || echo "Starting $VARIANT kernel build..."
	echo " "
	mkdir -p $SRC_DIR/out
	make $MAKE_PARAMS CC="ccache clang" vendor/$DEFCONFIG
	echo " "
	# Regen defconfig
	cp $SRC_DIR/out/.config $SRC_DIR/arch/arm64/configs/vendor/$DEFCONFIG
	echo " "
}

PACK_BOOT_IMG()
{
	echo "----------------------------------------------"
	echo "Packing $VARIANT boot.img..."
	rm -rf $OUT_DIR/tmp/
	mkdir $OUT_DIR/tmp/
	# Copy and unpack stock boot.img
	cp $OUT_DIR/a52/boot.img $OUT_DIR/tmp/boot.img
	cd $OUT_DIR/tmp/
	avbtool erase_footer --image boot.img
	magiskboot_x86 unpack -h boot.img
	# Replace KernelRPValue
	sed '1 c\name='"$RP_REV"'' header > header_new
	rm -f header
	mv header_new header
	# Replace stock kernel image
	rm -f $OUT_DIR/tmp/kernel
	rm -f $OUT_DIR/tmp/dtb
	cp $SRC_DIR/out/arch/arm64/boot/Image $OUT_DIR/tmp/kernel
	cp $SRC_DIR/out/arch/arm64/boot/dts/qcom/atoll-ab-idp.dtb $OUT_DIR/tmp/dtb
	# Repack and copy in out folder
	magiskboot_x86 repack boot.img boot_new.img
	cp $OUT_DIR/tmp/boot_new.img $OUT_DIR/Builds/${SPARK_VERSION_1}//Spark_${SPARK_VERSION}_${CODENAME}_boot.img
	mv $OUT_DIR/tmp/boot_new.img $OUT_DIR/out/zip/{SPARK_VERSION}.img
	# Clean :3
	rm -rf $OUT_DIR/tmp/
	cd $MAIN_DIR/
}

SWITCH_BRANCH()
{
	cd $SRC_DIR
	if test "$(git rev-parse --abbrev-ref HEAD)" = ascendia-14; then
		echo "----------------------------------------------"
		echoild Detected..."
		git switch ascendia-14-aosp
	elif test "$(git rev-parse --abbrev-ref HEAD)" = ascendia-14-ksu; then
		echo "----------------------------------------------"
		echo "KSU Branch Detected..."
		git switch ascendia-14-ksu-aosp
	else
		echo "----------------------------------------------"
		echo "Check Branch..."
		exit
	fi
 
}

MAKE_INSTALLER()
{
	cp $OUT_DIR/update-binary/${TYPE} $OUT_DIR/out/zip/META-INF/com/google/android/update-binary
	cd $OUT_DIR/out/zip/
	sed -i -e "s/VERSION_CODE/$ASC_VERSION2/g" $OUT_DIR/out/zip/META-INF/com/google/android/update-binary
	zip -r $OUT_DIR/Builds/${ASC_VERSION1}/${ASC_VERSION2}/Ascendia_${ASC_VERSION2}_${TYPE}_a572q.zip ascendia META-INF
	rm -rf $OUT_DIR/out/
}

# Do stuff
clear

rm -rf $OUT_DIR/out
rm -f $OUT_DIR/tmp/*.img

mkdir -p $OUT_DIR/out
cp -r $OUT_DIR/zip-template $OUT_DIR/out/zip
mkdir -p $OUT_DIR/out/zip/ascendia/a52
mkdir -p $OUT_DIR/out/zip/ascendia/a72
mkdir -p $OUT_DIR/Builds/${ASC_VERSION1}/${ASC_VERSION2}

# a52q
VARIANT=a52
CODENAME=a52q
RP_REV=SRPTH31C002
DEFCONFIG=a52q_eur_open_defconfig
CHECK_BRANCH
CLEAN_SOURCE
BUILD_KERNEL
PACK_BOOT_IMG

# a72q
VARIANT=a72
CODENAME=a72q
RP_REV=SRPTJ06B001
DEFCONFIG=a72q_eur_open_defconfig
CHECK_BRANCH
CLEAN_SOURCE
BUILD_KERNEL
PACK_BOOT_IMG
SWITCH_BRANCH

# a52q
VARIANT=a52
CODENAME=a52q
RP_REV=SRPTH31C002
DEFCONFIG=a52q_eur_open_defconfig
CHECK_BRANCH
CLEAN_SOURCE
BUILD_KERNEL
PACK_BOOT_IMG

# a72q
VARIANT=a72
CODENAME=a72q
RP_REV=SRPTJ06B001
DEFCONFIG=a72q_eur_open_defconfig
CHECK_BRANCH
CLEAN_SOURCE
BUILD_KERNEL
PACK_BOOT_IMG
MAKE_INSTALLER

echo "----------------------------------------------"

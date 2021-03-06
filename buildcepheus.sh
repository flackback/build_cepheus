#!/bin/bash
rm .version

make clean
make mrproper
rm -r toolchain
rm -r toolchains
rm -r out
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 toolchain
tar vxzf snapdragon-llvm-8.0.6-linux64.tar.gz

clear

# Resources
THREAD="-j8"
KERNEL="Image"
DTBIMAGE="dtb"

mkdir out

export CLANG_PATH=${PWD}/toolchains/llvm-Snapdragon_LLVM_for_Android_8.0/prebuilt/linux-x86_64/bin/clang/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=${PWD}/toolchain/bin/aarch64-linux-android-- CC=clang CXX=clang++
export CXXFLAGS="$CXXFLAGS -fPIC"
export DTC_EXT=dtc

DEFCONFIG="cepheus_user_defconfig"

# Paths
KERNEL_DIR=`pwd`
ZIMAGE_DIR="${PWD}/out/arch/arm64/boot/"

# Kernel Details
VER=".*Versao*"

# Vars
BASE_AK_VER="PIXON"
AK_VER="$BASE_AK_VER$VER"
export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="AndersonFagundes"
export KBUILD_BUILD_HOST="Linux-16-1"


DATE_START=$(date +"%s")

echo -e "${green}"
echo "-------------------"
echo "Making Kernel:"
echo "-------------------"
echo -e "${restore}"

echo
make CC=clang CXX=clang++ O=out $DEFCONFIG
make CC=clang CXX=clang++ O=out $THREAD 2>&1 | tee kernel.log

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
cd $ZIMAGE_DIR
ls -a

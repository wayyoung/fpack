# run build_sfdisk-arm.sh first for libblkid
export CC=arm-linux-gnueabihf-gcc
INSTALL_PATH="$(pwd -P)/install/arm"
TOP_PATH="$(pwd -P)"
echo "INSTALL_PATH=$INSTALL_PATH"
sleep 3
cd ${TOP_PATH}
cd libaio-0.3.112
make
make prefix=$INSTALL_PATH install
cd ${TOP_PATH}

cd lvm2-2_02_185
export CFLAGS=-I${INSTALL_PATH}/include
export LDFLAGS=-L${INSTALL_PATH}/lib
export CXXFLAGS=-I${INSTALL_PATH}/include
./configure --host=arm-linux-gnueabihf --enable-static_link --prefix=$INSTALL_PATH

make device-mapper
rm -Rf $INSTALL_PATH/bin/dmsetup.static
cp -f tools/dmsetup.static $INSTALL_PATH/bin
cd ${TOP_PATH}




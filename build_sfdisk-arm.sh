INSTALL_PATH="$(pwd -P)/install/arm"
TOP_PATH="$(pwd -P)"
echo "INSTALL_PATH=$INSTALL_PATH"
sleep 3
cd ${TOP_PATH}
cd ncurses-6.1
rm -Rf .build
mkdir -p .build
cd .build
../configure --host=arm-linux-gnueabihf --enable-widec --prefix=$INSTALL_PATH
make;make install
cd ${TOP_PATH}
cd util-linux-2.33
rm -Rf .build
mkdir -p .build
touch *
cd .build
../configure --prefix=$INSTALL_PATH  --host=arm-linux-gnueabihf CFLAGS=-I${INSTALL_PATH}/include LDFLAGS=-L${INSTALL_PATH}/lib --enable-static-programs=fdisk,sfdisk --enable-libfdisk --enable-libuuid --without-python --without-systemd  --enable-libblkid --disable-makeinstall-chown
make;make install



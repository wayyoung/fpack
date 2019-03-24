INSTALL_PATH="$(pwd -P)/install/arm"
TOP_PATH="$(pwd -P)"
echo "INSTALL_PATH=$INSTALL_PATH"
sleep 3
cd ${TOP_PATH}
cd e2fsprogs-1.44.5
rm -Rf .build
mkdir -p .build
cd .build
../configure --disable-nls CC=arm-linux-gnueabihf-gcc --host=arm-linux-gnueabihf --prefix=$INSTALL_PATH
make clean;make;make install



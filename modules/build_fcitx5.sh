#!/bin/bash

WPS_LIBRARY_DIR=$PWD/deb-package/opt/kingsoft/wps-office/office6

sed -i 's/^CFG_INOTIFY=.*/CFG_INOTIFY=no/g' configure
./configure -opensource -confirm-license -prefix $PWD
# Build only the necessary part
make -C src/tools/bootstrap
make -C src/tools/moc
make -C src/tools/uic
make -C src/tools/rcc
make -C src/corelib

# Replace the mismatch qconfig with wps ones.
chmod +w src/corelib/global/qconfig.h
sed -i 's|\(#define QT_BUILD_KEY.*\) ".*"|\1 "x86_64 Linux clang full-config"|g' src/corelib/global/qconfig.h

cd fcitx5-wps
mkdir build
cd build
cmake -DQT_QMAKE_EXECUTABLE=$PWD/../../bin/qmake -DWPS_LIBRARY_DIR=$WPS_LIBRARY_DIR ..
make install

cp $WPS_LIBRARY_DIR/qt/plugins/inputmethods/qtim-fcitx.so /app/lib



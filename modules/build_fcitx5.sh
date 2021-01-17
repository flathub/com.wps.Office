#!/bin/bash

WPS_LIBRARY_DIR=$PWD/wps

sed -i 's/^CFG_INOTIFY=.*/CFG_INOTIFY=no/g' configure
./configure -opensource -confirm-license -prefix $PWD
# Build only the necessary part
make -C src/tools/bootstrap -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/moc -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/uic -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/rcc -j$FLATPAK_BUILDER_N_JOBS
make -C src/corelib -j$FLATPAK_BUILDER_N_JOBS

# Replace the mismatch qconfig with wps ones.
chmod +w src/corelib/global/qconfig.h
sed -i 's|\(#define QT_BUILD_KEY.*\) ".*"|\1 "x86_64 Linux clang full-config"|g' src/corelib/global/qconfig.h

cd fcitx5-wps
mkdir build
cd build
cmake -DQT_QMAKE_EXECUTABLE=$PWD/../../bin/qmake -DWPS_LIBRARY_DIR=$WPS_LIBRARY_DIR ..
make -j$FLATPAK_BUILDER_N_JOBS
make install

mkdir -p /app/lib/qt
mv $WPS_LIBRARY_DIR/qt/plugins/inputmethods/ /app/lib/qt



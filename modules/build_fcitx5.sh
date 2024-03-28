#!/bin/bash
set -e

pushd qt
sed -i 's/^CFG_INOTIFY=.*/CFG_INOTIFY=no/g' configure
./configure \
    -opensource \
    -confirm-license \
    -prefix $PWD
# Build only the necessary part
make sub-src-qmake_all -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/bootstrap -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/moc -j$FLATPAK_BUILDER_N_JOBS
make -C src/corelib -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/uic -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/rcc -j$FLATPAK_BUILDER_N_JOBS
make -C src/dbus -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/qdbuscpp2xml -j$FLATPAK_BUILDER_N_JOBS
make -C src/tools/qdbusxml2cpp -j$FLATPAK_BUILDER_N_JOBS

# Replace the mismatch qconfig with wps ones.
chmod +w src/corelib/global/qconfig.h
sed -i 's|\(#define QT_BUILD_KEY.*\) ".*"|\1 "x86_64 Linux clang full-config"|g' src/corelib/global/qconfig.h
popd

pushd fcitx5-wps
cmake \
    -DQt5_DIR=$PWD/../qt/lib/cmake/Qt5 \
    -DWPS_LIBRARY_DIR=$FLATPAK_DEST/lib \
    -S . -B build
make -C build -j$FLATPAK_BUILDER_N_JOBS
make -C build install
popd

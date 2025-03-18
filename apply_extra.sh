#!/bin/bash
set -e
shopt -s failglob
FLATPAK_ID="${FLATPAK_ID:-com.wps.Office}"

mkdir -p deb-package export/share

ar p wps-office.deb data.tar.xz | tar -xJf - -C deb-package

mv deb-package/opt/kingsoft/wps-office .
mv deb-package/usr/bin/{wps,wpp,et,wpspdf} wps-office/
mv deb-package/usr/share/{icons,applications,mime} export/share/

YEAR_SUFFIX=2023

rename --no-overwrite "wps-office-" "${FLATPAK_ID}." export/share/{icons/hicolor/*/*,applications,mime/packages}/wps-office-*.*
rename --no-overwrite "wps-office${YEAR_SUFFIX}-" "${FLATPAK_ID}." export/share/icons/hicolor/*/*/wps-office${YEAR_SUFFIX}-*.*

for a in wps wpp et pdf prometheus; do
    desktop_file="export/share/applications/${FLATPAK_ID}.$a.desktop"
    appbin="$a"
    appicon="${FLATPAK_ID}.${a}main"
    case "$a" in
        pdf)
            appbin=wpspdf
        ;;
        prometheus)
            appbin=wps
            appicon="${FLATPAK_ID}.k${a}"
            # Use this as the main .desktop file for the Flatpak
            new_desktop_file="$(dirname $desktop_file)/${FLATPAK_ID}.desktop"
            mv $desktop_file $new_desktop_file
            desktop_file=$new_desktop_file
        ;;
    esac
    desktop-file-edit \
        --set-key="Exec" --set-value="$appbin %f" \
        --set-key="Icon" --set-value="$appicon" \
        --set-key="X-Flatpak-RenamedFrom" --set-value="wps-office-$a.desktop;" \
        "$desktop_file"
done
sed -i "s/generic-icon name=\"wps-office-/icon name=\"${FLATPAK_ID}./g" "export/share/mime/packages/${FLATPAK_ID}".*.xml

# Just use libstdc++.so.6 from the runtime; allows working with runtime 22.08+
rm wps-office/office6/libstdc++.so.6

rm -r wps-office.deb deb-package

# Remove plugin path so we can override the default path with based on QT_PLUGIN_PATH
sed -i 's|^Plugins=.*||g' wps-office/office6/qt.conf

# Fix wps deprecated python2 command
# https://aur.archlinux.org/cgit/aur.git/tree/fix-wps-python-parse.patch?h=wps-office-cn
sed -i 's/python -c '\''import sys, urllib; print urllib.unquote(sys.argv\[1\])'\''/python -c '\''import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))'\''/' wps-office/wps


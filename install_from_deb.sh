#!/bin/bash
set -e
shopt -s failglob
FLATPAK_ID="${FLATPAK_ID:-com.wps.Office}"

mkdir -p deb-package

ar p wps-office.deb data.tar.xz | tar -xJf - -C deb-package

mv deb-package/opt/kingsoft/wps-office /app
mv deb-package/usr/bin/{wps,wpp,et,wpspdf} /app/wps-office

YEAR_SUFFIX=2019

rename --no-overwrite "wps-office-" "${FLATPAK_ID}." deb-package/usr/share/{icons/hicolor/*/*,applications,mime/packages}/wps-office-*.*
rename --no-overwrite "wps-office${YEAR_SUFFIX}-" "${FLATPAK_ID}." deb-package/usr/share/icons/hicolor/*/*/wps-office${YEAR_SUFFIX}-*.*

for a in icons applications mime fonts templates; do
    find "deb-package/usr/share/$a" -type f -exec chmod 644 {} +
    mv "deb-package/usr/share/$a" /app/share/
done

for a in wps wpp et pdf prometheus; do
    desktop_file="/app/share/applications/${FLATPAK_ID}.$a.desktop"
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
sed -i "s/generic-icon name=\"wps-office-/icon name=\"${FLATPAK_ID}./g" "/app/share/mime/packages/${FLATPAK_ID}".*.xml

rm -r wps-office.deb deb-package

# Remove plugin path so we can override the default path with based on QT_PLUGIN_PATH
sed -i 's|^Plugins=.*||g' /app/wps-office/office6/qt.conf
#!/bin/bash
set -e
shopt -s failglob
FLATPAK_ID="${FLATPAK_ID:-com.wps.Office}"

mkdir -p deb-package export/share

ar p wps-office.deb data.tar.xz | tar -xJf - -C deb-package

mv deb-package/opt/kingsoft/wps-office .
mv deb-package/usr/bin/{wps,wpp,et,wpspdf} wps-office/
mv deb-package/usr/share/{icons,applications,mime} export/share/

YEAR_SUFFIX=2019

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
        ;;
    esac
    desktop-file-edit \
        --set-key="Exec" --set-value="$appbin %f" \
        --set-key="Icon" --set-value="$appicon" \
        --set-key="X-Flatpak-RenamedFrom" --set-value="wps-office-$a.desktop;" \
        "$desktop_file"
done
sed -i "s/generic-icon name=\"wps-office-/icon name=\"${FLATPAK_ID}./g" "export/share/mime/packages/${FLATPAK_ID}".*.xml

while read -r lang; do
    for target in mui dicts/spellcheck; do
        if [ ! -e "wps-office/office6/$target/$lang" ]; then
            ln -sr "/app/share/wps-office/office6/$target/$lang/data" "wps-office/office6/$target/$lang"
        fi
    done
done </app/share/wps-office/locales-list.txt

rm -r wps-office.deb deb-package

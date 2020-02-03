#!/bin/bash
set -e
shopt -s failglob

mkdir -p deb-package export/share

ar p wps-office.deb data.tar.xz | tar -xJf - -C deb-package

mv deb-package/opt/kingsoft/wps-office .
mv deb-package/usr/bin/{wps,wpp,et,wpspdf} wps-office/
mv deb-package/usr/share/{icons,applications,mime} export/share/

YEAR_SUFFIX=2019

rename --no-overwrite "wps-office-" "com.wps.Office." export/share/{icons/hicolor/*/*,applications,mime/packages}/wps-office-*.*
rename --no-overwrite "wps-office${YEAR_SUFFIX}-" "com.wps.Office." export/share/icons/hicolor/*/*/wps-office${YEAR_SUFFIX}-*.*

for a in wps wpp et pdf prometheus; do
    desktop_file="export/share/applications/com.wps.Office.$a.desktop"
    appbin="$a"
    appicon="com.wps.Office.${a}main"
    case "$a" in
        pdf)
            appbin=wpspdf
        ;;
        prometheus)
            appbin=wps
            appicon="com.wps.Office.k${a}"
        ;;
    esac
    desktop-file-edit \
        --set-key="Exec" --set-value="$appbin %f" \
        --set-key="Icon" --set-value="$appicon" \
        --set-key="X-Flatpak-RenamedFrom" --set-value="wps-office-$a.desktop;" \
        "$desktop_file"
done
sed -i 's/generic-icon name="wps-office-/icon name="com.wps.Office./g' export/share/mime/packages/com.wps.Office.*.xml

for l in /app/share/wps/office6/mui/*; do
    d=$(basename $l)
    test -d wps-office/office6/mui/$d || ln -sr /app/share/wps/office6/mui/$d wps-office/office6/mui/$d
done

rm -r wps-office.deb deb-package

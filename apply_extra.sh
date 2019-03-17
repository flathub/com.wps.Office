#!/bin/bash
set -e

mkdir -p wps-office export/share

tar -xJf wps.tar.xz --strip-components=1 -C wps-office

cp -ax wps-office/resource/{icons,applications,mime} export/share/

rename "wps-office-" "com.wps.Office." export/share/{icons/hicolor/*/*,applications,mime/packages}/wps-office-*.*
rename "appurl" "com.wps.Office.appurl" export/share/applications/appurl.desktop

for a in wps wpp et; do
    sed -i "s|/opt/kingsoft/wps-office|/app/extra/wps-office|g" -i wps-office/$a
    desktop_file="export/share/applications/com.wps.Office.$a.desktop"
    desktop-file-edit --set-key="Exec" --set-value="$a %f" "$desktop_file"
    desktop-file-edit --set-key="Icon" --set-value="com.wps.Office.${a}main" "$desktop_file"
    desktop-file-edit --set-key="X-Flatpak-RenamedFrom" --set-value="wps-office-$a.desktop;" "$desktop_file"
done

appurl_desktop_file="export/share/applications/com.wps.Office.appurl.desktop"
desktop-file-edit --set-key="Exec" --set-value="parsecloudfiletool %u" "$appurl_desktop_file"

sed -i 's/generic-icon name="wps-office-/icon name="com.wps.Office./g' export/share/mime/packages/com.wps.Office.*.xml

for l in /app/share/wps/office6/mui/*; do
    d=$(basename $l)
    test -d wps-office/office6/mui/$d || ln -sr /app/share/wps/office6/mui/$d wps-office/office6/mui/$d
done

rm wps.tar.xz

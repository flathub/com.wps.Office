#!/bin/bash
set -e

mkdir -p deb-package export/share

ar p wps-office.deb data.tar.xz | tar -xJf - -C deb-package

mv deb-package/opt/kingsoft/wps-office .
mv deb-package/usr/bin/{wps,wpp,et,wpspdf} wps-office/
mv deb-package/usr/share/{icons,applications,mime} export/share/
rm export/share/applications/appurl.desktop

rename "wps-office-" "com.wps.Office." export/share/{icons/hicolor/*/*,applications,mime/packages}/wps-office-*.*

for a in wps wpp et pdf; do
    desktop_file="export/share/applications/com.wps.Office.$a.desktop"
    desktop-file-edit --set-key="Exec" --set-value="$a %f" "$desktop_file"
    desktop-file-edit --set-key="Icon" --set-value="com.wps.Office.${a}main" "$desktop_file"
    desktop-file-edit --set-key="X-Flatpak-RenamedFrom" --set-value="wps-office-$a.desktop;" "$desktop_file"
done
sed -i 's/generic-icon name="wps-office-/icon name="com.wps.Office./g' export/share/mime/packages/com.wps.Office.*.xml

for l in /app/share/wps/office6/mui/*; do
    d=$(basename $l)
    test -d wps-office/office6/mui/$d || ln -sr /app/share/wps/office6/mui/$d wps-office/office6/mui/$d
done

rm -r wps-office.deb deb-package

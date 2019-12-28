#!/usr/bin/env bash

CONF_FILE="${XDG_CONFIG_HOME}/Kingsoft/Office.conf"

BACKUPS_SUBDIR="Kingsoft/office6/data/backup"
OLD_BACKUP_PATH="${HOME}/.local/share/${BACKUPS_SUBDIR}"
NEW_BACKUP_PATH="${XDG_DATA_HOME}/${BACKUPS_SUBDIR}"

if [ -f "${CONF_FILE}" ]; then
    echo "Config exists, updating paths"
    sed "s|${OLD_BACKUP_PATH}|${NEW_BACKUP_PATH}|g" -i "${CONF_FILE}"
else
    echo "No config exists, creating one"
    mkdir -p "$(dirname "${CONF_FILE}")"
    cat <<EOF > "${CONF_FILE}"
[6.0]
common\Backup\AutoRecoverFilePath=${NEW_BACKUP_PATH}
EOF
fi

exec "/app/extra/wps-office/$(basename "$0")" "$@"

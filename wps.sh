#!/usr/bin/env bash

CONF_FILE="${XDG_CONFIG_HOME}/Kingsoft/Office.conf"

BACKUPS_SUBDIR="Kingsoft/office6/data/backup"
OLD_BACKUP_PATH="${HOME}/.local/share/${BACKUPS_SUBDIR}"
NEW_BACKUP_PATH="${XDG_DATA_HOME}/${BACKUPS_SUBDIR}"

if [ ! -f "${CONF_FILE}" ]; then
    echo "No config exists, creating one"
    mkdir -p "${NEW_BACKUP_PATH}"
    mkdir -p "$(dirname "${CONF_FILE}")"
    cat <<EOF > "${CONF_FILE}"
[6.0]
common\Backup\AutoRecoverFilePath=${NEW_BACKUP_PATH}
EOF
elif grep -q "${OLD_BACKUP_PATH}" "${CONF_FILE}"; then
    echo "Config file contains old paths, updating"
    mkdir -p "${NEW_BACKUP_PATH}"
    sed "s|${OLD_BACKUP_PATH}|${NEW_BACKUP_PATH}|g" -i "${CONF_FILE}"
fi

exec "/app/extra/wps-office/$(basename "$0")" "$@"

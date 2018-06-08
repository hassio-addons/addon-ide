#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: IDE
# Sets up the Cloud9 IDE project Workspace
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

mkdir /workspace || hass.die 'Unable to create a workspace directory'

readonly -a directories=(addons backup config share ssl)

for dir in "${directories[@]}"; do
    ln -s "/${dir}" "/workspace/${dir}" \
        || hass.log.warning "Failed linking common directory: ${dir}"
done

# Symlink workspace setting to data folder
if ! hass.directory_exists "/data/.c9"; then
    mkdir /data/.c9
fi

ln -s /data/.c9 /workspace/.c9

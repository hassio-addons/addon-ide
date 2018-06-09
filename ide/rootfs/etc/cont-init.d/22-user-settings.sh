#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: IDE
# Sets up the user settings
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.file_exists "/data/user.settings"; then
    hass.log.debug "Setting up default user settings..."
    cp /root/.c9/user.settings /data/user.settings
fi

# Symlink the user.setting file
rm -f /root/.c9/user.settings
ln -s /data/user.settings /root/.c9/user.settings

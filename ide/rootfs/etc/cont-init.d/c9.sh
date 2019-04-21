#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: IDE
# Configures the Cloud9 IDE
# ==============================================================================
readonly -a directories=(addons backup config share ssl)
readonly SSH_USER_PATH=/data/.ssh
readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTANT_FILE=/data/.zsh_history

# Links some common directories to the user's home folder for convenience
for dir in "${directories[@]}"; do
    ln -s "/${dir}" "${HOME}/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
    ln -s "/${dir}" "/workspace/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
done

# Symlink workspace setting to data folder
if ! bashio::fs.directory_exists "/data/.c9"; then
    bashio::log.debug "Setting up default project settings..."
    cp -R /workspace/.c9 /data/.c9
fi

rm -fr /workspace/.c9
ln -s /data/.c9 /workspace/.c9

if ! bashio::fs.file_exists "/data/user.settings"; then
    bashio::log.debug "Setting up default user settings..."
    cp /root/.c9/user.settings /data/user.settings
fi

# Symlink the user.setting file
rm -f /root/.c9/user.settings
ln -s /data/user.settings /root/.c9/user.settings

# Persist ZSH data
touch "${ZSH_HISTORY_PERSISTANT_FILE}" \
    || bashio::exit.nok 'Failed creating a persistent ZSH history file'

chmod 600 "$ZSH_HISTORY_PERSISTANT_FILE" \
    || bashio::exit.nok 'Failed setting the correct permissions to the ZSH history file'

ln -s -f "$ZSH_HISTORY_PERSISTANT_FILE" "$ZSH_HISTORY_FILE" \
    || bashio::exit.nok 'Failed linking the persistant ZSH history file'

# Sets up the users .ssh folder to be persistent
if ! bashio::fs.directory_exists "${SSH_USER_PATH}"; then
    mkdir -p "${SSH_USER_PATH}" \
        || bashio::exit.nok 'Failed to create a persistent .ssh folder'

    chmod 700 "${SSH_USER_PATH}" \
        || bashio::exit.nok 'Failed setting permissions on persistent .ssh folder'
fi

ln -s "${SSH_USER_PATH}" ~/.ssh

# Install user configured/requested packages
if bashio::config.has_value 'packages'; then
    apk update \
        || bashio::exit.nok 'Failed updating Alpine packages repository indexes'

    for package in $(bashio::config 'packages'); do
        apk add "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi

# Executes user configured/requested commands on startup
if bashio::config.has_value 'init_commands'; then
    while read -r cmd; do
        eval "${cmd}" \
            || bashio::exit.nok "Failed executing init command: ${cmd}"
    done <<< "$(bashio::config 'init_commands')"
fi

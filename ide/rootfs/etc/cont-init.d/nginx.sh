#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: IDE
# Configure the use of SSL in NGINX
# ==============================================================================
declare hassio_dns

bashio::config.require.ssl
if bashio::config.true 'ssl'; then
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')

    sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/nginx-ssl.conf
    sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/nginx-ssl.conf
fi

hassio_dns=$(bashio::dns.host)
sed -i "s/%%hassio_dns%%/${hassio_dns}/g" /etc/nginx/nginx-ssl.conf
sed -i "s/%%hassio_dns%%/${hassio_dns}/g" /etc/nginx/nginx.conf

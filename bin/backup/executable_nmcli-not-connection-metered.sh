#!/bin/bash

# Use network manager to get current connection's metered status
# returns true if connection is *not* metered
#
# Set connection to metered via
# nmcli connection modify $CONNECTION connection.metered yes

# Get current active connection UUID
connection_uuid=$(nmcli -t -m multiline -f UUID connection show --active | head -n1 | cut -c 6- )

# Get current active connnection metered status
metered=$(nmcli -t -m multiline -f connection.metered connection show "$connection_uuid" | cut -c 20-)

case $metered in
    unknown)
        exit 0
        ;;
    no)
        exit 0
        ;;
    yes)
        exit 1
        ;;
esac

#!/usr/bin/env bash

export SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

# Stop logging and kill rpcbind
systemctl stop rsyslog
systemctl stop rpcbind
systemctl disable rpcbind

# Clear our log files
logrotate -f /etc/logrotate.conf;
rm -f /var/lib/dhcp/dhclient*.leases
rm -f /var/log/apache2/*
rm -f /var/log/*.[1-9]
rm -f /var/log/*/*.[1-9]
rm -f /var/log/*.gz
rm -f /var/log/*/*.gz
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog

# Purge history, tmp, and source files
unset HISTFILE
/bin/cat /dev/null > /root/.bash_history
rm -rf $SCRIPT_DIR/
rm -rf /tmp/*
rm -rf /var/tmp/*
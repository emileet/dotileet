#!/bin/sh

SERVICE_NAME="$1"

if systemctl --user is-active $SERVICE_NAME >/dev/null 2>&1; then
    systemctl --user stop $SERVICE_NAME
else
    systemctl --user start $SERVICE_NAME
fi

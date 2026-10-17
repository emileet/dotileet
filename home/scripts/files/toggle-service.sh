#!/bin/sh

SERVICE_NAME="$1"

if [ -z "$SERVICE_NAME" ]; then
    echo "usage: $0 <service-name>" >&2
    exit 1
fi

if systemctl --user is-active --quiet "$SERVICE_NAME"; then
    systemctl --user stop "$SERVICE_NAME"
else
    systemctl --user start "$SERVICE_NAME"
fi

systemctl --user is-active "$SERVICE_NAME"

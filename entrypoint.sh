#!/bin/sh
set -e

cat > /tmp/usbrelayd.conf <<EOF
[MQTT]
# Hostname or IP address of your MQTT Broker
BROKER = ${MQTT_BROKER:-mqtt}
# Name your client connects as
CLIENTNAME = ${MQTT_CLIENTNAME:-MyUSBRelay}
TLS = ${MQTT_TLS:-}
USER = ${MQTT_USER:-}
PASS = ${MQTT_PASS:-}
PORT = ${MQTT_PORT:-1883}
TOPIC = ${MQTT_TOPIC:-}
EOF

exec python3 /usr/local/sbin/usbrelayd
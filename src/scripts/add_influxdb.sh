#!/bin/bash -e

GRAFANA_USERNAME=${GRAFANA_USERNAME:-admin}
GRAFANA_PASSWORD=${GRAFANA_PASSWORD:-admin}
GRAFANA_HOST=${GRAFANA_HOST:-localhost}
GRAFANA_PORT=${GRAFANA_PORT:-3000}
INFLUXDB_HOST=${INFLUXDB_HOST:-localhost}
INFLUXDB_PORT=${INFLUXDB_PORT:-8086}

curl 'http://admin:admin@localhost:3000/api/datasources' \
    -X POST -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "name":"influx",
        "type":"influxdb",
        "url":"http://localhost:8086",
        "access":"direct",
        "isDefault":true,
        "database":"services",
        "user":"n/a","password":"n/a"
      }'
DATASOURCE

#!/bin/bash -e

GRAFANA_USERNAME=${GRAFANA_USERNAME:-admin}
GRAFANA_PASSWORD=${GRAFANA_PASSWORD:-admin}
GRAFANA_HOST=${GRAFANA_HOST:-localhost}
GRAFANA_PORT=${GRAFANA_PORT:-3000}
DEPLOY_ENVIRONMENT=${BAMBOO_DEPLOY_ENVIRONMENT:-localhost}
INFLUXDB_PORT=${INFLUXDB_PORT:-8086}

if [ "${DEPLOY_ENVIRONMENT}" = "localhost" ]; then
  INFLUXDB_API="http://localhost:${INFLUXDB_PORT}"
else
  INFLUXDB_API="http://server-${DEPLOY_ENVIRONMENT}.corp:${INFLUXDB_PORT}"
fi

echo $INFLUXDB_HOST

curl "http://${GRAFANA_USERNAME}:${GRAFANA_PASSWORD}@${GRAFANA_HOST}:${GRAFANA_PORT}/api/datasources" \
    -X POST -H "Content-Type: application/json" \
    --data-binary <<DATASOURCE \
      '{
        "name":"influx",
        "type":"influxdb",
        "url":"'"${INFLUXDB_API}"'",
        "access":"direct",
        "isDefault":true,
        "database":"services",
        "user":"n/a","password":"n/a"
      }'
DATASOURCE

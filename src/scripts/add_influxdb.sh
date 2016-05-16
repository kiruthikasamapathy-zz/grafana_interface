#!/bin/bash -e

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

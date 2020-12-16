#!/bin/bash

ad='192.168.1.136:9200'
echo curl --location --request PUT "'$ad/cryptos'"
echo curl --location --request PUT "'$ad/cryptos/_settings'" --header 'Content-Type: application/json' --data-raw '{
  "index.mapping.total_fields.limit": 5000
}'

#!/bin/bash

ad='192.168.8.46:9200'

curl --location --request PUT "$ad/cryptos" > init.log
curl --location --request PUT "$ad/cryptos/_settings" --header 'Content-Type: application/json' --data-raw '{
  "index.mapping.total_fields.limit": 5000
}' >> init.log

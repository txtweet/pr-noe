#!/bin/bash

source ./elastic.creds
#ad='192.168.8.46:9200'
ad='localhost:9100'

curl -u $user:$passwd -sS --location --request PUT "$ad/cryptos" |json
curl -u $user:$passwd -sS --location --request PUT "$ad/cryptos/_settings" --header 'Content-Type: application/json' --data-raw '{
  "index.mapping.total_fields.limit": 5000
}' |json

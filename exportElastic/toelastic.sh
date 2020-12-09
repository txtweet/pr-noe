#!/bin/bash
set `date +%d%m%Y`

curl "https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?aux=circulating_supply,tags,max_supply,total_supply&convert=USD&cryptocurrency_type=all&limit=50&sort=market_cap&sort_dir=desc&start=1" --output ../cryptos-$*.json

coffee ./cryptosToElastic.coffee $* > data_elastic-$*.json

#curl -XPUT localhost:9200/_bulk -H"Content-Type: application/json" --data-binary @data_elastic.json

#!/bin/bash
echo "Récupération des données dans crypto-$*.json"

set `date +%d%m%Y`

curl -sS "https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?aux=circulating_supply,tags,max_supply,total_supply&convert=USD&cryptocurrency_type=all&limit=5000&sort=market_cap&sort_dir=desc&start=1"|json > ../cryptos-$*.json

echo "coffee ./addNewCryptosFromFreshData.coffee $* > toto.json"
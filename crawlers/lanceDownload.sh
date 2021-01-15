#!/bin/bash

set `date +%d%m%Y`
echo "Récupération des données dans crypto-$*.json"

curl -sS "https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?aux=circulating_supply,tags,max_supply,total_supply&convert=USD&cryptocurrency_type=all&limit=5000&sort=market_cap&sort_dir=desc&start=1"|json > ../cryptos-$*.json
echo "git add ../cryptos-$*.json && git commit -am'Ajout cryptos' && git push"
echo "coffee ./addNewCryptosFromFreshData.coffee $* > toto.json"

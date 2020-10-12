while true; do
  echo "Tick"
  coffee ./crawl.coffee > cryptos2.json 
  cp ./cryptos2.json cryptos.json
  sleep 10
done

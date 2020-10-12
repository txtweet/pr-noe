while true; do
  echo "Tick"
  coffee ./crawl.coffee > cryptos2.json 
  cp ./cryptos2.json cryptos.json
  git add cryptos.json
  sleep 60
done

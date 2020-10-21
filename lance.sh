while true; do
  echo "Tick"
  coffee ./crawl.coffee > cryptos2.json
  cp ./cryptos2.json cryptos.json
  # git add cryptos.json
  sleep 60

  echo "Token"
  coffee ./crawlTokens.coffee > tokens.json
  cp ./tokens.json cryptos.json

  sleep 15

  echo "Token2"
  coffee ./crawlTokens.coffee > tokens.json
  cp ./tokens.json cryptos.json
  sleep 60

done
